#=
The code in here has been extracted from the JuliaParser.jl package
with license:

The JuliaParser.jl package is licensed under the MIT "Expat" License:

> Copyright (c) 2014: Jake Bolewski.
>
> Permission is hereby granted, free of charge, to any person obtaining
> a copy of this software and associated documentation files (the
> "Software"), to deal in the Software without restriction, including
> without limitation the rights to use, copy, modify, merge, publish,
> distribute, sublicense, and/or sell copies of the Software, and to
> permit persons to whom the Software is furnished to do so, subject to
> the following conditions:
>
> The above copyright notice and this permission notice shall be
> included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
> EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
> MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
> IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
> CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
> TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
> SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=#

const EOF_CHAR = typemax(Char)

function is_identifier_char(c::Char)
  c == EOF_CHAR && return false
    if ((c >= 'A' && c <= 'Z') ||
        (c >= 'a' && c <= 'z') || c == '_' ||
        (c >= '0' && c <= '9') )
        return true
    end
    return false
end

function is_identifier_start_char(c::Char)
    c == EOF_CHAR && return false
    if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z') || c == '_')
        return true
    end
    return false
end

eof(io::IO) = Base.eof(io)
eof(c::Char) = c === EOF_CHAR
readchar(io::IO) = eof(io) ? EOF_CHAR : read(io, Char)
