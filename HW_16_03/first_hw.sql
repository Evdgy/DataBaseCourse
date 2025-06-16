-- Создаем базу данных french_cuisine и выбираем ее для работы
CREATE DATABASE french_cuisine;
USE french_cuisine;

-- Создаем таблицу categories для хранения категорий блюд
-- Поля: уникальный идентификатор (CategoryID) и название категории (CategoryName)
CREATE TABLE categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(50) NOT NULL
);

-- Создаем таблицу recipes для хранения рецептов
-- Поля: уникальный идентификатор рецепта (RecipeID), название (RecipeName), категория (CategoryID),
-- инструкции приготовления (Instructions), время приготовления в минутах (CookingTime)
-- Связь с categories через внешний ключ CategoryID
CREATE TABLE recipes (
    RecipeID INT PRIMARY KEY AUTO_INCREMENT,
    RecipeName VARCHAR(100) NOT NULL,
    CategoryID INT,
    Instructions TEXT,
    CookingTime INT,
    FOREIGN KEY (CategoryID) REFERENCES categories(CategoryID)
        ON DELETE SET NULL -- при удалении категории, у рецептов категория станет NULL
);

-- Создаем таблицу ingredients для хранения ингредиентов
-- Поля: уникальный идентификатор (IngredientID), название ингредиента (IngredientName), единица измерения (Unit_Si)
CREATE TABLE ingredients (
    IngredientID INT PRIMARY KEY AUTO_INCREMENT,
    IngredientName VARCHAR(100) NOT NULL,
    Unit_Si VARCHAR(20) NOT NULL
);

-- Создаем связывающую таблицу recipeingredients для связи рецептов и ингредиентов с указанием количества
-- composite primary key из RecipeID и IngredientID
-- внешние ключи к таблицам recipes и ingredients с каскадным удалением
CREATE TABLE recipeingredients (
    RecipeID INT,
    IngredientID INT,
    Quantity INT,
    PRIMARY KEY (RecipeID, IngredientID),
    FOREIGN KEY (RecipeID) REFERENCES recipes(RecipeID)
        ON DELETE CASCADE,
    FOREIGN KEY (IngredientID) REFERENCES ingredients(IngredientID)
        ON DELETE CASCADE
);

-- Заполняем таблицу категорий четырьмя основными категориями французской кухни
INSERT INTO categories (CategoryName) VALUES 
('Завтрак'), 
('Основное'),
('Закуска'), 
('Десерт');

-- Заполняем таблицу ингредиентов с указанием единиц измерения
INSERT INTO ingredients (IngredientName, Unit_Si) VALUES
('Яйцо', 'шт'),
('Молоко', 'мл'),
('Мука', 'г'),
('Сыр', 'г'),
('Лук репчатый', 'г'),
('Сливки', 'мл'),
('Грибы шампиньоны', 'г'),
('Сахар', 'г'),
('Сливки жирные', 'мл'),
('Ваниль', 'г'),
('Яичный желток', 'шт'),
('Багет', 'г'),
('Масло сливочное', 'г');

-- Добавляем рецепты для категории "Завтрак" с инструкциями и временем приготовления
INSERT INTO recipes (RecipeName, CategoryID, Instructions, CookingTime) VALUES
('Омлет', 1, 'Взбить яйца с молоком, жарить на сковороде.', 10),
('Блинчики', 1, 'Смешать ингредиенты, обжарить блины с двух сторон.', 20),
('Французский тост', 1, 'Обмакнуть багет в яичную смесь и поджарить.', 15);

-- Рецепты категории "Основное"
INSERT INTO recipes (RecipeName, CategoryID, Instructions, CookingTime) VALUES
('Луковый суп', 2, 'Карамелизовать лук, добавить бульон и томить. Подача с гренками и сыром.', 60),
('Киш с овощами', 2, 'Выложить овощи и заливку в тесто, запечь.', 45),
('Кок-о-вен', 2, 'Тушить курицу в вине с овощами и специями.', 90);

-- Рецепты категории "Закуска"
INSERT INTO recipes (RecipeName, CategoryID, Instructions, CookingTime) VALUES
('Жульен с грибами', 3, 'Обжарить грибы со сливками, посыпать сыром и запечь.', 30),
('Салат Нисуаз', 3, 'Смешать овощи, яйцо, рыбу и заправку.', 20),
('Фаршированные яйца', 3, 'Отварить яйца, нафаршировать желтками с майонезом.', 15);

-- Рецепты категории "Десерт"
INSERT INTO recipes (RecipeName, CategoryID, Instructions, CookingTime) VALUES
('Крем-брюле', 4, 'Запечь смесь сливок, желтков и сахара. Посыпать сахаром и карамелизовать.', 90),
('Круассаны', 4, 'Сформировать из теста и запечь.', 60),
('Мусс из шоколада', 4, 'Взбить сливки и растопленный шоколад. Охладить.', 25);

-- Связываем ингредиенты с рецептом "Омлет", указывая количество каждого ингредиента
INSERT INTO recipeingredients VALUES 
(1, 1, 2),  -- 2 яйца
(1, 2, 50), -- 50 мл молока
(1, 4, 30); -- 30 г сыра

-- Связываем ингредиенты с рецептом "Блинчики"
INSERT INTO recipeingredients VALUES 
(2, 1, 2),
(2, 2, 150),
(2, 3, 100);

-- Связываем ингредиенты с рецептом "Французский тост"
INSERT INTO recipeingredients VALUES 
(3, 1, 1),
(3, 2, 70),
(3, 12, 60),
(3, 13, 20);

-- Связываем ингредиенты с рецептом "Луковый суп"
INSERT INTO recipeingredients VALUES 
(4, 5, 200),
(4, 4, 30);

-- Связываем ингредиенты с рецептом "Жульен с грибами"
INSERT INTO recipeingredients VALUES 
(7, 7, 150),
(7, 6, 100),
(7, 4, 40);

-- Связываем ингредиенты с рецептом "Крем-брюле"
INSERT INTO recipeingredients VALUES 
(10, 9, 200),
(10, 11, 3),
(10, 8, 60),
(10, 10, 2);

-- Удаляем рецепт "Фаршированные яйца"
DELETE FROM recipes
WHERE RecipeName = 'Фаршированные яйца';

-- Добавляем в таблицу recipes новый столбец Difficulty (сложность)
ALTER TABLE recipes
ADD COLUMN Difficulty VARCHAR(20);

-- Удаляем добавленный столбец Difficulty
ALTER TABLE recipes
DROP COLUMN Difficulty;

-- Запрос на вывод названий рецептов из категории "Десерт"
SELECT RecipeName
FROM recipes
WHERE CategoryID = (
    SELECT CategoryID FROM categories WHERE CategoryName = 'Десерт'
);

-- Запрос рецептов категории "Завтрак", время приготовления которых меньше 30 минут
SELECT RecipeName, CookingTime
FROM recipes
WHERE CookingTime < 30
  AND CategoryID = (
    SELECT CategoryID FROM categories WHERE CategoryName = 'Завтрак'
);

-- Запрос ингредиентов с единицами измерения "г" или "мл"
SELECT IngredientName, Unit_Si
FROM ingredients
WHERE Unit_Si = 'г' OR Unit_Si = 'мл';

-- Запрос первых 10 рецептов из таблицы recipes
SELECT * FROM recipes LIMIT 10;