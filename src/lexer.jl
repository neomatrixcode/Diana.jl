
include("utilities.jl")

import ..Tokens
import ..Tokens: Token, Kind, TokenError,  EMPTY_TOKEN
import ..Tokens:  NAME

mutable struct Lexing
    io::IO
    io_startpos::Int

    token_start_row::Int
    token_start_col::Int

    prevpos::Int
    token_startpos::Int

    current_row::Int
    current_col::Int
    current_pos::Int

    last_token::Tokens.Kind
end

Lexing(io::IO) = Lexing(io, position(io), 1, 1, -1, 0, 1, 1, position(io), Tokens.ERROR)
Lexing(str::AbstractString) = Lexing(IOBuffer(str))

Tokensgraphql(x) = collect(Lexing(x))
caracter_ignored(c::Char) = Base.isspace(c) #'\n   \t'
# Iterator interface
Base.IteratorSize(::Type{Lexing}) = Base.SizeUnknown()
Base.IteratorEltype(::Type{Lexing}) = Base.HasEltype()
Base.eltype(::Type{Lexing}) = Token

function Base.iterate(l::Lexing)
    seek(l.io, l.io_startpos)
    l.token_startpos = position(l)
    l.token_start_row = 1
    l.token_start_col = 1

    l.current_row = 1
    l.current_col = 1
    l.current_pos = l.io_startpos
    t = next_token(l)
    return t, t.kind == Tokens.ENDMARKER
end

function Base.iterate(l::Lexing, isdone::Any)
    isdone && return nothing
    t = next_token(l)
    return t, t.kind == Tokens.ENDMARKER
end

Base.show(io::IO, l::Lexing) = print(io, typeof(l), " at position: ", position(l))

"""
    startpos(l::Lexing)

Return the latest `Token`'s starting position.
"""
startpos(l::Lexing) = l.token_startpos

"""
    prevpos(l::Lexing)

Return the lexer's previous position.
"""
prevpos(l::Lexing) = l.prevpos

"""
    position(l::Lexing)

Returns the current position.
"""
Base.position(l::Lexing) = Base.position(l.io)

"""
    eof(l::Lexing)

Determine whether the end of the lexer's underlying buffer has been reached.
"""
eof(l::Lexing) = eof(l.io)

Base.seek(l::Lexing, pos) = seek(l.io, pos)

"""
    readchar(l::Lexing)

Returns the next character and increments the current position.
"""
function readchar(l::Lexing)
    l.prevpos = position(l)
    c = readchar(l.io)
    return c
end


"""
    emit(l::Lexing, kind::Kind, str::String,
                       err::TokenError=Tokens.NO_ERR)

Returns a `Token` of kind `kind` with contents `str` and starts a new `Token`.
"""
function emit(l::Lexing, kind::Kind, str::String, err::TokenError = Tokens.NO_ERR)
   tok= Token(kind, (l.token_start_row, l.token_start_col),
                (l.current_row, l.current_col),
                startpos(l), position(l) - 1,
                str, err)
    l.last_token = kind
    l.current_col += 1
    return tok
end

"""
    emit_error(l::Lexing, str::String, err::TokenError=Tokens.UNKNOWN)

Returns an `ERROR` token with error `err` and starts a new `Token`.
"""
function emit_error(l::Lexing, str::String, err::TokenError = Tokens.UNKNOWN)
    return throw(ErrorGraphql("{\"errors\":[{\"locations\": [{\"column\": $(l.current_col),\"line\": $(l.current_row)}],\"message\": \"Syntax Error GraphQL request ($(l.current_row):$(l.current_col)) Unexpected character $(str) \"}]}"))
end

function emit_error(l::Lexing, str::Char, err::TokenError = Tokens.UNKNOWN)
    if caracter_ignored(str)
       return throw(ErrorGraphql("{\"errors\":[{\"locations\": [{\"column\": $(l.current_col),\"line\": $(l.current_row)}],\"message\": \"Syntax Error GraphQL request ($(l.current_row):$(l.current_col)) Unexpected character $(escape_string(string(str))) \"}]}"))
    end

    return throw(ErrorGraphql("{\"errors\":[{\"locations\": [{\"column\": $(l.current_col),\"line\": $(l.current_row)}],\"message\": \"Syntax Error GraphQL request ($(l.current_row):$(l.current_col)) Unexpected character $(str) \"}]}"))
end



"""
    next_token(l::Lexing)

Returns the next `Token`.
"""
function next_token(l::Lexing)
   c= readchar(l)

   if c == ','
      l.current_col += 1
      c= readchar(l)
   end

    while c == '#'
      while c!='\n'
        l.current_col += 1
        c= readchar(l)
      end
      l.current_row += 1
      l.current_col = 1
     c= readchar(l)
   end

    while caracter_ignored(c)
        if c == '\n'
            l.current_row += 1
            l.current_col = 1
        elseif c== '\t'
           l.current_col += 5
        else
           l.current_col += 1
         end
        c= readchar(l)

        while c == '#'
          while c!='\n'
            l.current_col += 1
            c= readchar(l)
          end
          l.current_row += 1
          l.current_col = 1
         c= readchar(l)
       end
    end

    l.token_startpos = position(l)
    l.token_start_row = l.current_row
    if l.current_col == 1
        l.token_start_col = 1
    else
        l.token_start_col = l.current_col
    end

    if eof(c); return emit(l,Tokens.ENDMARKER,"eof")
    elseif c == '['; return emit(l, Tokens.LSQUARE,"[")
    elseif c == ']'; return emit(l, Tokens.RSQUARE,"]")
    elseif c == '{'; return emit(l, Tokens.LBRACE,"{")
    elseif c == '}'; return emit(l, Tokens.RBRACE,"}")
    elseif c == '('; return emit(l, Tokens.LPAREN,"(")
    elseif c == ')'; return emit(l, Tokens.RPAREN,")")
    elseif c == '|'; return emit(l, Tokens.PIPE,"|")
    elseif c == '@'; return emit(l, Tokens.AT,"@")
    elseif c == '$'; return emit(l, Tokens.DOLLAR,"\$")
    elseif c == '='; return emit(l, Tokens.EQUALS,"=")
    elseif c == '!'; return emit(l, Tokens.BANG,"!")
    elseif c == ':'; return emit(l, Tokens.COLON,":")
    elseif c == '&'; return emit(l, Tokens.AMP,"&")
    elseif c == '"'; return lex_quote(l,c);
    elseif is_identifier_start_char(c); return lex_identifier(l, c)
    elseif c == '.'; return lex_dot(l);
    elseif c == '-'; return lex_digit(l,c);
    elseif isdigit(c); return lex_digit(l,c)
    else return emit_error(l,string(c))
    end

end

function lex_quote(l::Lexing, c::Char)
    multiline= false
    s= ""
    s*=c
    c= readchar(l)
    l.current_col += 1

    if c=='"'
        c= readchar(l)
        if c=='"'
         c= readchar(l)
         multiline= true
        else
         return emit_error(l,string(c))
        end
    end

    while c!='"'
        if multiline==true

            if c == '\n'
                l.current_row += 1
                l.current_col = 1
            elseif c== '\t'
               l.current_col += 4
            end

            s*=c
            l.current_col += 1
            c= readchar(l)
        else
            if c=='\n'
                return emit_error(l,c)
            else
                s*=c
                l.current_col += 1
                c= readchar(l)
            end
        end
    end
    s*="\""
    if (multiline==true)
        c= readchar(l)
        if c=='"'
            l.current_col += 1
            c= readchar(l)
            if c=='"'
                l.current_col += 1
            else
                return emit_error(l,string(c))
            end
        else
            return emit_error(l,string(c))
        end
    end

    return emit(l, Tokens.STRING, s)
end

function lex_identifier(l::Lexing, c::Char)
    s= ""
    while is_identifier_char(c)
        s*=c
        c= readchar(l)
        l.current_col += 1
    end
    l.current_col -= 1
    seek(l, prevpos(l))
    return emit(l, NAME,s)
end

function lex_dot(l::Lexing)
    if readchar(l) == '.'
        if readchar(l) == '.'
            return emit(l, Tokens.SPREAD, "...")
        end
    end
    return emit_error(l," ")
end


# A digit has been consumed
function lex_digit(l::Lexing, c::Char)
    s=""
    isfloat=false
    s*=c
    c= readchar(l)
    l.current_col += 1

    while isdigit(c)
        s*=c
        c= readchar(l)
        l.current_col += 1
    end

    if c=='.'
        s*=c
        c= readchar(l)
        l.current_col += 1
        isfloat=true
        if isdigit(c)
            s*=c
            c= readchar(l)
            l.current_col += 1
            while isdigit(c)
                s*=c
                c= readchar(l)
                l.current_col += 1
            end
        else
            return emit_error(l,c)
        end
    end

    if ((c=='e') || (c== 'E'))
        s*=c
        c= readchar(l)
        l.current_col += 1
        isfloat=true
        if ((c=='+') || (c=='-'))
            s*=c
            c= readchar(l)
            l.current_col += 1
        end
        if isdigit(c)
            s*=c
            c= readchar(l)
            l.current_col += 1
            while isdigit(c)
                s*=c
                c= readchar(l)
                l.current_col += 1
            end
        else
            return emit_error(l,c)
        end
    end

    l.current_col -= 1
    seek(l, prevpos(l))

    if isfloat==true
        return emit(l, Tokens.FLOAT,s)
    end
    return emit(l, Tokens.INT, s)
end