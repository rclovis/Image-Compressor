##
## EPITECH PROJECT, 2023
## Makefile
## File description:
## Makefile
##

NAME	=	imageCompressor

LOCAL_INSTALL_ROOT	=	$(shell stack path --local-install-root)

$(NAME):
		stack build --ghc-options="-O2"
		cp "${LOCAL_INSTALL_ROOT}/bin/imageCompressor-exe" ./${NAME}

clean:
		stack clean

all:	$(NAME)

fclean: clean
		rm -f $(NAME)

re: fclean all

time:
		stack build --ghc-options="-O2" --profile
		cp "${LOCAL_INSTALL_ROOT}/bin/imageCompressor-exe" ./${NAME}
		stack exec --profile -- imageCompressor-exe +RTS -p -RTS  -f pixels/mona-lisa.jpg.in -n 20 -l 0.5

.PHONY: all clean fclean re