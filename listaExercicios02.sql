DELIMITER //
CREATE PROCEDURE sp_ListarAutores()
BEGIN
    SELECT * FROM Autor;
END //
DELIMITER ;

-- Teste da stored procedure
CALL sp_ListarAutores();

DELIMITER //
CREATE PROCEDURE sp_LivrosPorCategoria(IN categoriaNome VARCHAR(100))
BEGIN
    SELECT Livro.Titulo
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoriaNome;
END //
DELIMITER ;

-- Teste da stored procedure
CALL sp_LivrosPorCategoria('Romance');

DELIMITER //
CREATE PROCEDURE sp_ContarLivrosPorCategoria(IN categoriaNome VARCHAR(100), OUT total INT)
BEGIN
    SELECT COUNT(*) INTO total
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoriaNome;
END //
DELIMITER ;

-- Teste da stored procedure
SET @total := 0;
CALL sp_ContarLivrosPorCategoria('Ciência', @total);
SELECT @total;

DELIMITER //
CREATE PROCEDURE sp_VerificarLivrosCategoria(IN categoriaNome VARCHAR(100), OUT temLivros BOOL)
BEGIN
    DECLARE total INT;
    CALL sp_ContarLivrosPorCategoria(categoriaNome, total);
    IF total > 0 THEN
        SET temLivros := TRUE;
    ELSE
        SET temLivros := FALSE;
    END IF;
END //
DELIMITER ;

-- Teste da stored procedure
SET @temLivros := NULL;
CALL sp_VerificarLivrosCategoria('História', @temLivros);
SELECT @temLivros;

DELIMITER //
CREATE PROCEDURE sp_LivrosAteAno(IN anoPublicacao INT)
BEGIN
    SELECT Titulo
    FROM Livro
    WHERE Ano_Publicacao <= anoPublicacao;
END //
DELIMITER ;

-- Teste da stored procedure
CALL sp_LivrosAteAno(2010);

DELIMITER //
CREATE PROCEDURE sp_TitulosPorCategoria(IN categoriaNome VARCHAR(100))
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE livroTitulo VARCHAR(255);
    DECLARE cur CURSOR FOR
        SELECT Livro.Titulo
        FROM Livro
        INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
        WHERE Categoria.Nome = categoriaNome;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO livroTitulo;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT livroTitulo;
    END LOOP;
    CLOSE cur;
END //
DELIMITER ;

-- Teste da stored procedure
CALL sp_TitulosPorCategoria('Ficção Científica');
