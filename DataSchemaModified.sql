-- Фізична схема реляційної бази даних
-- Програмний продукт для контролю тренувань
-- із гімнастичною палицею
-- СУБД: PostgreSQL

-- 1. Користувач
CREATE TABLE users (
    user_id INTEGER GENERATED ALWAYS AS IDENTITY,
    CONSTRAINT pk_users PRIMARY KEY (user_id)
);

-- 2. Гімнастична палиця
CREATE TABLE sticks (
    stick_id INTEGER GENERATED ALWAYS AS IDENTITY,
    stick_name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL,

    CONSTRAINT pk_sticks PRIMARY KEY (stick_id),

    CONSTRAINT chk_stick_name CHECK (
        stick_name ~ '^[А-Яа-яІіЇїЄєҐґA-Za-z0-9 ]+$'
    ),

    CONSTRAINT chk_stick_description CHECK (
        description ~ '^[А-Яа-яІіЇїЄєҐґA-Za-z0-9 ,.!-]+$'
    )
);

-- 3. Тренування
CREATE TABLE trainings (
    training_id INTEGER GENERATED ALWAYS AS IDENTITY,
    user_id INTEGER NOT NULL,
    stick_id INTEGER NOT NULL,
    repetition_count INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT pk_trainings PRIMARY KEY (training_id),

    CONSTRAINT fk_trainings_users FOREIGN KEY (user_id)
    REFERENCES users (user_id),

    CONSTRAINT fk_trainings_sticks FOREIGN KEY (stick_id)
    REFERENCES sticks (stick_id),

    CONSTRAINT chk_repetition_count CHECK (repetition_count >= 0)
);

-- 4. Рух гімнастичної палиці
CREATE TABLE movements (
    movement_id INTEGER GENERATED ALWAYS AS IDENTITY,
    stick_id INTEGER NOT NULL,

    CONSTRAINT pk_movements PRIMARY KEY (movement_id),

    CONSTRAINT fk_movements_sticks FOREIGN KEY (stick_id)
    REFERENCES sticks (stick_id)
);

-- 5. Параметри руху
CREATE TABLE movement_parameters (
    parameters_id INTEGER GENERATED ALWAYS AS IDENTITY,
    movement_id INTEGER NOT NULL,
    acceleration REAL NOT NULL,
    angular_velocity REAL NOT NULL,

    CONSTRAINT pk_movement_parameters PRIMARY KEY (parameters_id),

    CONSTRAINT fk_parameters_movements FOREIGN KEY (movement_id)
    REFERENCES movements (movement_id),

    CONSTRAINT uq_parameters_movement UNIQUE (movement_id),

    CONSTRAINT chk_acceleration CHECK (
        acceleration BETWEEN -100 AND 100
    ),

    CONSTRAINT chk_angular_velocity CHECK (
        angular_velocity BETWEEN -50 AND 50
    )
);

-- 6. Повторення
CREATE TABLE repetitions (
    repetition_id INTEGER GENERATED ALWAYS AS IDENTITY,
    training_id INTEGER NOT NULL,
    movement_id INTEGER NOT NULL,

    CONSTRAINT pk_repetitions PRIMARY KEY (repetition_id),

    CONSTRAINT fk_repetitions_trainings FOREIGN KEY (training_id)
    REFERENCES trainings (training_id),

    CONSTRAINT fk_repetitions_movements FOREIGN KEY (movement_id)
    REFERENCES movements (movement_id)
);
