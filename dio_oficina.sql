-- Criando banco de dados de oficina

-- DROP DATABASE oficina;
-- -----------------------------------------------------
-- Database oficina
-- -----------------------------------------------------
CREATE DATABASE IF NOT EXISTS `oficina`;
USE `oficina` ;

-- -----------------------------------------------------
-- Table `oficina`.`Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oficina`.`Fornecedor` (
  `idFornecedor` INT NOT NULL auto_increment,
  `Nome` VARCHAR(45) NOT NULL,
  `CNPJ` CHAR(14) NOT NULL,
  `Telefone` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`idFornecedor`)
  );


-- -----------------------------------------------------
-- Table `oficina`.`Cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oficina`.`Cliente` (
  `idCliente` INT NOT NULL auto_increment,
  `Nome` VARCHAR(45) NOT NULL,
  `Sobrenome` VARCHAR(45) NOT NULL,
  `Endereco` VARCHAR(100) NOT NULL,
  `Telefone` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`idCliente`)
  );


-- -----------------------------------------------------
-- Table `oficina`.`Servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oficina`.`Servico` (
  `idServico` INT NOT NULL auto_increment,
  `Descricao` VARCHAR(45) NULL,
  `Cliente_idCliente` INT NOT NULL,
  PRIMARY KEY (`idServico`),
  CONSTRAINT `fk_Servico_Cliente1`
    FOREIGN KEY (`Cliente_idCliente`)
    REFERENCES `oficina`.`Cliente` (`idCliente`)
    );


-- -----------------------------------------------------
-- Table `oficina`.`Pecas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oficina`.`Pecas` (
  `idPecas` INT NOT NULL AUTO_INCREMENT,
  `Nome` VARCHAR(45) NOT NULL,
  `Quantidade` INT UNSIGNED NOT NULL,
  `Descricao` VARCHAR(45) NULL,
  `Estoque` ENUM('Em estoque', 'Em falta') NULL DEFAULT 'Em falta',
  `Servico_idServico` INT NOT NULL,
  PRIMARY KEY (`idPecas`),
  CONSTRAINT `fk_Pecas_Servico1`
    FOREIGN KEY (`Servico_idServico`)
    REFERENCES `oficina`.`Servico` (`idServico`)
    );


-- -----------------------------------------------------
-- Table `oficina`.`Mecanico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oficina`.`Mecanico` (
  `idMecanico` INT NOT NULL auto_increment,
  `Nome` VARCHAR(45) NOT NULL,
  `Sobrenome` VARCHAR(45) NOT NULL,
  `Telefone` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`idMecanico`)
  );


-- -----------------------------------------------------
-- Table `oficina`.`Pecas_Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oficina`.`Pecas_Fornecedor` (
  `Pecas_idPecas` INT NOT NULL,
  `Fornecedor_idFornecedor` INT NOT NULL,
  PRIMARY KEY (`Pecas_idPecas`, `Fornecedor_idFornecedor`),
  CONSTRAINT `fk_Pecas_has_Fornecedor_Pecas`
    FOREIGN KEY (`Pecas_idPecas`)
    REFERENCES `oficina`.`Pecas` (`idPecas`),
  CONSTRAINT `fk_Pecas_has_Fornecedor_Fornecedor1`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `oficina`.`Fornecedor` (`idFornecedor`)
    );


-- -----------------------------------------------------
-- Table `oficina`.`Mecanico_Servico`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `oficina`.`Mecanico_Servico` (
  `Mecanico_idMecanico` INT NOT NULL,
  `Servico_idServico` INT NOT NULL,
  PRIMARY KEY (`Mecanico_idMecanico`, `Servico_idServico`),
  CONSTRAINT `fk_Mecanico_has_Servico_Mecanico1`
    FOREIGN KEY (`Mecanico_idMecanico`)
    REFERENCES `oficina`.`Mecanico` (`idMecanico`),
  CONSTRAINT `fk_Mecanico_has_Servico_Servico1`
    FOREIGN KEY (`Servico_idServico`)
    REFERENCES `oficina`.`Servico` (`idServico`)
    );


-- -----------------------------------------------------
-- Inserindo dados
-- -----------------------------------------------------
-- Fornecedor
-- Cliente
-- Servico
-- Pecas
-- Mecanico
-- Pecas_Fornecedor
-- Mecanico_Servico
-- -----------------------------------------------------

insert into Fornecedor (Nome, CNPJ, Telefone) values
	('Carburadogs', '11111111111111', '4133332211'),
    ('Suspensão Thriller', '22222222222222', '41999994455'), 
    ('Alfaluzes', '33333333333333', '41987654321'),
    ('Marcinho Escapamentos', '44444444444444', '41912345678');
 
 insert into Cliente (Nome, Sobrenome, Endereco, Telefone) values
	('José', 'de Paula', 'Av dos Estados, 123, Curitiba', '41999887766'),
    ('Lucia', 'Brito', 'Rua XV de Novembro, 455, Curitiba', '4133457889'),
    ('Maria', 'Silva', 'Av República Argentina, 1129, Curitiba', '41999993322');
    
 insert into Servico (Descricao, Cliente_idCliente) values
	(null, 1),
    ('Troca de lâmpada traseira esquerda', 2),
    (null, 2);
    
 insert into Pecas (Nome, Quantidade, Descricao, Estoque, Servico_idServico) values
	('Lâmpada', 1, null, 'Em estoque', 2),
    ('Pneu', 5, null, 'Em estoque', 1),
    ('Carburador', 0, null, default, 1),
    ('Saída do escapamento', 1, null, 'Em estoque', 3);
    
 insert into Mecanico (Nome, Sobrenome, Telefone) values
	('Elias', 'Jonas', '4133336666'),
    ('Samuel', 'Pedroso', '41955554433');
    
 insert into Pecas_Fornecedor (Pecas_idPecas, Fornecedor_idFornecedor) values
	(1, 3),
    (2, 2),
    (3, 1),
    (4, 4);
    
 insert into Mecanico_Servico (Mecanico_idMecanico, Servico_idServico) values
	(1, 1),
    (2, 1),
    (1, 2),
    (2, 2);

-- -----------------------------------------------------
-- Inserindo dados
-- -----------------------------------------------------

-- Quantos clientes existem
select count(*) from Cliente;

-- Nome da peça, quantidade, estoque, nome do fornecedor e telefone do fornecedor
select p.Nome as Peca, p.Quantidade,  p.Estoque, f.Nome as Fornecedor, f.Telefone
	from Pecas p
	inner join Pecas_Fornecedor pf on idPecas = Pecas_idPecas
	inner join Fornecedor f on idFornecedor = Fornecedor_idFornecedor
    order by Estoque;

-- Nome e sobrenome de cliente que não tem nenhum serviço em andamento
select Nome, Sobrenome from Cliente 
	left outer join Servico 
    on idCliente = Cliente_idCliente 
    where idServico is null;

-- Quantidade de serviços, número do serviço e nome dos clientes
select count(*) as Quantidade, idServico as Numero_Servico, concat(c.Nome, ' ', c.Sobrenome) as Cliente
	from Servico inner join Mecanico_Servico on idServico=Servico_idServico
    inner join Mecanico on idMecanico=Mecanico_idMecanico
    inner join Cliente c on idCliente=Cliente_idCliente
	group by idServico;