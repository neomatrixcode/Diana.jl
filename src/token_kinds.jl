@enum(Kind,
    ENDMARKER, # EOF
    ERROR,
    COMMENT, # aadsdsa, #= fdsf #=
    WHITESPACE, # '\n   \t'
    IDENTIFIER, # foo, Σxx
    AT_SIGN, # @
    COMMA, #,
    SEMICOLON, # ;

    begin_keywords,
        KEYWORD, # general
        QUERY,
        MUTATION,
        SUBSCRIPTION,
    end_keywords,

    begin_literal,
        LITERAL, # general
        INTEGER, # 4
        FLOAT, # 3.5, 3.7e+3
        STRING, # "foo"
        TRIPLE_STRING, # """ foo \n """
        CHAR, # 'a'
        TRUE, FALSE, 
    end_literal,

    begin_delimiters,
        LSQUARE, # [
        RSQUARE, # [
        LBRACE, # {
        RBRACE, # }
        LPAREN, # (
        RPAREN,  # )
    end_delimiters,

    begin_ops,
        OP, # general
        DDDOT, # ...

        # Level 1
        begin_assignments,
            EQ, # =
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
            DDOT, # ..
        end_colon,

        # Level 9
        begin_plus,
            EX_OR, # $
            PLUS, # +
            MINUS, # -
        end_plus,

        # Level 11
        begin_times,
            STAR,  # *
        end_times,

        # Level 16
        begin_dot,
            DOT,# .
        end_dot,

        NOT, # !
        PRIME, # '
       
    end_ops,
)