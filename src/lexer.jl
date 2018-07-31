module Lexers

include("utilities.jl")
global const charstore = IOBuffer()

#using Compat
#import Compat.String

import ..Tokens
import ..Tokens: Token, Kind, TokenError,  EMPTY_TOKEN

import ..Tokens:  NAME


export tokenize

@inline iswhitespace(c::Char) = Base.isspace(c)

mutable struct Lexer
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

Lexer(io::IO) = Lexer(io, position(io), 1, 1, -1, 0, 1, 1, position(io), Tokens.ERROR)
Lexer(str::AbstractString) = Lexer(IOBuffer(str))

"""
    Tokenize(x)

Returns an `Iterable` containing the tokenized input. Can be reverted by e.g.
`join(untokenize.(Tokenize(x)))`.
"""
function Tokenize(x)
 x=replace(x, r"#.*\n" => "\n") # quit comments
 Lexer(x)
end

function Tokensgraphql(x)
 x=replace(x, r"#.*\n" => "\n") # quit comments
 #@time collect(Lexer(y))
 filter(x -> (x.kind != Tokens.WHITESPACE), collect(Lexer(x)))
end
# Iterator interface
Base.IteratorSize(::Type{Lexer}) = Base.SizeUnknown()
Base.IteratorEltype(::Type{Lexer}) = Base.HasEltype()
Base.eltype(::Type{Lexer}) = Token

function Base.start(l::Lexer)
    seekstart(l)
    l.token_startpos = position(l)
    l.token_start_row = 1
    l.token_start_col = 1

    l.current_row = 1
    l.current_col = 1
    l.current_pos = l.io_startpos
    false
end

function Base.next(l::Lexer, ::Any)
    t = next_token(l)
    return t, t.kind == Tokens.ENDMARKER
end

Base.done(::Lexer, isdone) = isdone

function Base.show(io::IO, l::Lexer)
    print(io, typeof(l), " at position: ", position(l))
end

"""
    startpos(l::Lexer)

Return the latest `Token`'s starting position.
"""
startpos(l::Lexer) = l.token_startpos

"""
    startpos!(l::Lexer, i::Integer)

Set a new starting position.
"""
startpos!(l::Lexer, i::Integer) = l.token_startpos = i

"""
    prevpos(l::Lexer)

Return the lexer's previous position.
"""
prevpos(l::Lexer) = l.prevpos

"""
    prevpos!(l::Lexer, i::Integer)

Set the lexer's previous position.
"""
prevpos!(l::Lexer, i::Integer) = l.prevpos = i

Base.seekstart(l::Lexer) = seek(l.io, l.io_startpos)

"""
    seek2startpos!(l::Lexer)

Sets the lexer's current position to the beginning of the latest `Token`.
"""
seek2startpos!(l::Lexer) = seek(l, startpos(l))

"""
    peekchar(l::Lexer)

Returns the next character without changing the lexer's state.
"""
peekchar(l::Lexer) = peekchar(l.io)

"""
    position(l::Lexer)

Returns the current position.
"""
Base.position(l::Lexer) = Base.position(l.io)

"""
    eof(l::Lexer)

Determine whether the end of the lexer's underlying buffer has been reached.
"""
eof(l::Lexer) = eof(l.io)

Base.seek(l::Lexer, pos) = seek(l.io, pos)

"""
    start_token!(l::Lexer)

Updates the lexer's state such that the next  `Token` will start at the current
position.
"""
function start_token!(l::Lexer)
    l.token_startpos = position(l)
    l.token_start_row = l.current_row
    l.token_start_col = l.current_col
end

"""
    prevchar(l::Lexer)

Returns the previous character. Does not change the lexer's state.
"""
function prevchar(l::Lexer)
    backup!(l)
    return readchar(l)
end

"""
    readchar(l::Lexer)

Returns the next character and increments the current position.
"""
function readchar end

function readchar(l::Lexer)
    prevpos!(l, position(l))
    c = readchar(l.io)
    return c
end

"""
    backup!(l::Lexer)

Decrements the current position and sets the previous position to `-1`, unless
the previous position already is `-1`.
"""
function backup!(l::Lexer)
    prevpos(l) == -1 && error("prevpos(l) == -1\n Cannot backup! multiple times.")
    seek(l, prevpos(l))
    prevpos!(l, -1)
end

"""
    accept(l::Lexer, f::Union{Function, Char, Vector{Char}, String})

Consumes the next character `c` if either `f::Function(c)` returns true, `c == f`
for `c::Char` or `c in f` otherwise. Returns `true` if a character has been
consumed and `false` otherwise.
"""
@inline function accept(l::Lexer, f::Union{Function, Char, Vector{Char}, String})
    c = peekchar(l)
    if isa(f, Function)
        ok = f(c)
    elseif isa(f, Char)
        ok = c == f
    else
        ok = c in f
    end
    ok && readchar(l)
    return ok
end

"""
    accept_batch(l::Lexer, f)

Consumes all following characters until `accept(l, f)` is `false`.
"""
@inline function accept_batch(l::Lexer, f)
    ok = false
    while accept(l, f)
        ok = true
    end
    return ok
end

"""
    emit(l::Lexer, kind::Kind,
         str::String=extract_tokenstring(l), err::TokenError=Tokens.NO_ERR)

Returns a `Token` of kind `kind` with contents `str` and starts a new `Token`.
"""
function emit(l::Lexer, kind::Kind,
              str::String = extract_tokenstring(l), err::TokenError = Tokens.NO_ERR)
    tok = Token(kind, (l.token_start_row, l.token_start_col),
                (l.current_row, l.current_col - 1),
                startpos(l), position(l) - 1,
                str, err)
    l.last_token = kind
    start_token!(l)
    return tok
end

"""
    emit_error(l::Lexer, err::TokenError=Tokens.UNKNOWN)

Returns an `ERROR` token with error `err` and starts a new `Token`.
"""
function emit_error(l::Lexer, err::TokenError = Tokens.UNKNOWN)
    return emit(l, Tokens.ERROR, extract_tokenstring(l), err)
end

"""
    extract_tokenstring(l::Lexer)

Returns all characters since the start of the current `Token` as a `String`.
"""
function extract_tokenstring(l::Lexer)
    global charstore
    curr_pos = position(l)
    seek2startpos!(l)

    while position(l) < curr_pos
        c = readchar(l)
        l.current_col += 1
        if c == '\n'
            l.current_row += 1
            l.current_col = 1
         end
        write(charstore, c)
    end
    str = String(take!(charstore))
    return str
end

"""
    next_token(l::Lexer)

Returns the next `Token`.
"""
function next_token(l::Lexer)
    c = readchar(l)

    if eof(c); return emit(l, Tokens.ENDMARKER)
    elseif iswhitespace(c); return lex_whitespace(l)
    elseif c == '['; return emit(l, Tokens.LSQUARE)
    elseif c == ']'; return emit(l, Tokens.RSQUARE)
    elseif c == '{'; return emit(l, Tokens.LBRACE)
    elseif c == '}'; return emit(l, Tokens.RBRACE)
    elseif c == '('; return emit(l, Tokens.LPAREN)
    elseif c == ')'; return emit(l, Tokens.RPAREN)
    elseif c == '|'; return emit(l, Tokens.PIPE)
    elseif c == '@'; return emit(l, Tokens.AT)
    elseif c == '$'; return emit(l, Tokens.DOLLAR)
    elseif c == '='; return emit(l, Tokens.EQUALS)
    elseif c == '!'; return emit(l, Tokens.BANG)
    elseif c == ':'; return emit(l, Tokens.COLON)
    elseif c == '&'; return emit(l, Tokens.AMP)
    elseif c == '"'; return lex_quote(l);
    elseif c == '.'; return lex_dot(l);
    elseif is_identifier_start_char(c); return lex_identifier(l, c)
    elseif isdigit(c); return lex_digit(l)
    else emit_error(l)
    end
end


# Lex whitespace, a whitespace char has been consumed
function lex_whitespace(l::Lexer)
    accept_batch(l, iswhitespace)
    return emit(l, Tokens.WHITESPACE)
end

function accept_integer(l::Lexer)
    !isdigit(peekchar(l)) && return false
    while true
        if !accept(l, isdigit)
            if accept(l, '_')
                if !isdigit(peekchar(l))
                    backup!(l)
                    return true
                end
            else
                return true
            end
        end
    end
end

# A digit has been consumed
function lex_digit(l::Lexer)
    backup!(l)
    longest, kind = position(l), Tokens.ERROR

    # accept_batch(l, isdigit)
    accept_integer(l)

    if accept(l, '.')
        if peekchar(l) == '.' # 43.. -> [43, ..]
            backup!(l)
            return emit(l, Tokens.INT)
        elseif !(isdigit(peekchar(l)) ||
            iswhitespace(peekchar(l)) ||
            is_identifier_start_char(peekchar(l))
            || peekchar(l) == '('
            || peekchar(l) == ')'
            || peekchar(l) == '['
            || peekchar(l) == ']'
            || peekchar(l) == '{'
            || peekchar(l) == '}'
            || peekchar(l) == ','
            || peekchar(l) == ';'
            || peekchar(l) == '@'
            || peekchar(l) == '`'
            || peekchar(l) == '"'
            || peekchar(l) == ':'
            || peekchar(l) == '?'
            || eof(l))
            backup!(l)
            return emit(l, Tokens.INT)
        end
        # accept_batch(l, isdigit)
        accept_integer(l)

        if accept(l, '.')
            if peekchar(l) == '.' # 1.23..3.21 is valid
                backup!(l)
                return emit(l, Tokens.FLOAT)
            elseif !(isdigit(peekchar(l)) || iswhitespace(peekchar(l)) || is_identifier_start_char(peekchar(l)))
                backup!(l)
                return emit(l, Tokens.FLOAT)
            else # 3213.313.3123 is an error
                return emit_error(l)
            end
        elseif position(l) > longest # 323213.3232 candidate
            longest, kind = position(l), Tokens.FLOAT
        end

        if accept(l, "eEf") # 1313.[0-9]*e
            accept(l, "+-")
            if accept_integer(l) && position(l) > longest
                longest, kind = position(l), Tokens.FLOAT
            end
        end
    elseif accept(l, "eEf")
        accept(l, "+-")
        if accept_integer(l) && position(l) > longest
            longest, kind = position(l), Tokens.FLOAT
        else
            backup!(l)
            return emit(l, Tokens.INT)
        end
    elseif position(l) > longest
        longest, kind = position(l), Tokens.INT
    end

    seek2startpos!(l)

    seek(l, longest)

    return emit(l, kind)
end


# Parse a token starting with a quote.
# A '"' has been consumed
function lex_quote(l::Lexer, doemit=true)
        if read_string(l, Tokens.STRING)
            return doemit ? emit(l, Tokens.STRING) : EMPTY_TOKEN
        else
            return doemit ? emit_error(l, Tokens.EOF_STRING) : EMPTY_TOKEN
        end
end

# We just consumed a "
function read_string(l::Lexer, kind::Tokens.Kind)
    while true
        c = readchar(l)
        if c == '\\'
            eof(readchar(l)) && return false
            continue
        end
        if c == '"'
            if kind == Tokens.STRING
                return true
            else
                if accept(l, "\"") && accept(l, "\"")
                    return true
                end
            end
        elseif eof(c)
            return false
        end
    end
end

function lex_dot(l::Lexer)
    if accept(l, '.')
        if accept(l, '.')
            return emit(l, Tokens.SPREAD)
        end
    end
end

function tryread(l, str, k, c)
    for s in str
        c = readchar(l)
        if c != s
            if !is_identifier_char(c)
                backup!(l)
                return emit(l, NAME)
            end
            return readrest(l, c)
        end
    end
    if is_identifier_char(peekchar(l))
        return readrest(l, c)
    end
    return emit(l, k)
end

function readrest(l, c)
    while is_identifier_char(c)
        if c == '!' && peekchar(l) == '='
            backup!(l)
            break
        elseif !is_identifier_char(peekchar(l))
            break
        end
        c = readchar(l)
    end

    return emit(l, NAME)
end


function _doret(l, c)
    if !is_identifier_char(c)
        backup!(l)
        return emit(l, NAME)
    else
        return readrest(l, c)
    end
end
#se queda
function lex_identifier(l, c)
    if c == 'q'
        return tryread(l, ('u', 'e', 'r', 'y'), NAME, c)
    elseif c == 'm'
        return tryread(l, ('u', 't', 'a', 't','i','o','n'), NAME, c)
    elseif c == 's'
        return tryread(l, ('u', 'b', 's', 'c','r','i','p', 't','i','o','n'), NAME, c)
    elseif c == 'f'
        return tryread(l, ('r', 'a', 'g', 'm','e','n','t'), NAME, c)

    elseif c == 'd'
        return tryread(l, ('i', 'r', 'e', 'c','t','i','v','e'), NAME, c)
    else
        return _doret(l, c)
    end
end

end # module
