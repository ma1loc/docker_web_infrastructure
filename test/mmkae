CPP = c++
COMPILE_FLAG = -std=c++98
CPP_FLAGS = -Wall -Wextra -Werror

NAME = a.out
SRC = main.cpp Init_Cat.cpp Init_Dog.cpp \
      WrongAnimal.cpp WrongCat.cpp ./Brain.cpp ./Init_AAnimal.cpp
OBJ = $(SRC:.cpp=.o)

all: $(NAME)

$(NAME): $(OBJ)
	$(CPP) $(COMPILE_FLAG) $(POLY) $(CPP_FLAGS) -o $(NAME) $(OBJ)

%.o: %.cpp
	$(CPP) $(COMPILE_FLAG) $(POLY) $(CPP_FLAGS) -c $< -o $@

clean:
	rm -f $(OBJ)

fclean: clean
	rm -f $(NAME)

re: fclean all
