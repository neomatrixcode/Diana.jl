@enum(Kind,
    ENDMARKER, # EOF
    ERROR,
    COMMENT, # aadsdsa, #= fdsf #=
    WHITESPACE, # '\n   \t'
    NAME, # foo, Σxx
    AT, # @
    PIPE, #|
    AMP, #&

    begin_keywords,
        KEYWORD, # general
    end_keywords,

    begin_literal,
        INT, # 4
        FLOAT, # 3.5, 3.7e+3
        STRING, # "foo"
        TRIPLE_STRING, # """ foo \n """
        TRUE, FALSE,
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

        # Level 1
        begin_assignments,
            EQUALS, # =
        end_assignments,


        # Level 8
        begin_colon,
            COLON, # :
        end_colon,

        # Level 9
        begin_plus,
            DOLLAR, # $
        end_plus,

        BANG, # !

    end_ops,
)