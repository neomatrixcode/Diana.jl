@enum(Kind,
    ENDMARKER, # EOF
    ERROR,
    COMMENT, # aadsdsa, #= fdsf #=
    WHITESPACE, # '\n   \t'
    NAME, # foo, Σxx
    AT, # @
    PIPE, #|
    COMMA, #,
    SEMICOLON, # ;
    AMP, #&

    begin_keywords,
        KEYWORD, # general
    end_keywords,

    begin_literal,
        LITERAL, # general
        INT, # 4
        FLOAT, # 3.5, 3.7e+3
        STRING, # "foo"
        TRIPLE_STRING, # """ foo \n """
        CHAR, # 'a'
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
        OP, # general
        SPREAD, # ...

        # Level 1
        begin_assignments,
            EQUALS, # =
        end_assignments,

        # Level 2
        begin_conditional,
            CONDITIONAL, # ?
        end_conditional,

        # Level 6
        begin_comparison,
            EQEQ, # ==
        end_comparison,

        # Level 8
        begin_colon,
            COLON, # :
        end_colon,

        # Level 9
        begin_plus,
            DOLLAR, # $
            PLUS, # +
            MINUS, # -
        end_plus,

        # Level 16
        begin_dot,
            DOT,# .
        end_dot,

        BANG, # !
        PRIME, # '

    end_ops,
)