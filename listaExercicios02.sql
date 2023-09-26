DELIMITER //
CREATE PROCEDURE sp_ListarAutores()
BEGIN
    SELECT * FROM Autor;
END //
DELIMITER ;

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


CALL sp_TitulosPorCategoria('Ficção Científica');

DELIMITER //
CREATE PROCEDURE sp_AdicionarLivro(IN livroTitulo VARCHAR(255), IN editoraID INT, IN anoPublicacao INT, IN numPaginas INT, IN categoriaID INT)
BEGIN
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Livro com título duplicado.';
    END;

    INSERT INTO Livro (Titulo, Editora_ID, Ano_Publicacao, Numero_Paginas, Categoria_ID)
    VALUES (livroTitulo, editoraID, anoPublicacao, numPaginas, categoriaID);
END //
DELIMITER ;


CALL sp_AdicionarLivro('A Jornada', 1, 2000, 320, 1); -- Isso deve gerar um erro de duplicação de título
CALL sp_AdicionarLivro('Novo Livro', 2, 2022, 250, 5); -- Isso deve adicionar um novo livro

DELIMITER //
CREATE PROCEDURE sp_AutorMaisAntigo(OUT autorNome VARCHAR(255))
BEGIN
    SELECT Nome INTO autorNome
    FROM Autor
    ORDER BY Data_Nascimento
    LIMIT 1;
END //
DELIMITER ;


SET @nomeMaisAntigo := NULL;
CALL sp_AutorMaisAntigo(@nomeMaisAntigo);
SELECT @nomeMaisAntigo;

DELIMITER //
CREATE PROCEDURE sp_LivrosPorCategoria(IN categoriaNome VARCHAR(100))
BEGIN
   
    
    SELECT Livro.Titulo
    FROM Livro
    INNER JOIN Categoria ON Livro.Categoria_ID = Categoria.Categoria_ID
    WHERE Categoria.Nome = categoriaNome;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_LivrosESeusAutores()
BEGIN
    SELECT Livro.Titulo, Autor.Nome, Autor.Sobrenome
    FROM Livro
    INNER JOIN Autor_Livro ON Livro.Livro_ID = Autor_Livro.Livro_ID
    INNER JOIN Autor ON Autor_Livro.Autor_ID = Autor.Autor_ID;
END //
DELIMITER ;


CALL sp_LivrosESeusAutores();

