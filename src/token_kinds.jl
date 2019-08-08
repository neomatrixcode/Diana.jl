@enum(Kind,
    ENDMARKER, # EOF
    ERROR,
    NAME, # foo, Σxx
    AT, # @
    PIPE, #|
    AMP, #&

    begin_literal,
        INT, # 4
        FLOAT, # 3.5, 3.7e+3
        STRING, # "foo"
        TRIPLE_STRING, # """ foo \n """
    end_literal,

    begin_delimiters,
        LSQUARE, # [
        RSQUARE, # ]
        LBRACE, # {
        RBRACE, # }
        LPAREN, # (
        RPAREN,  # )
    end_delimiters,

    begin_ops,
        SPREAD, # ...
        EQUALS, # =
        COLON, # :
        DOLLAR, # $
        BANG, # !
    end_ops,
)