DROP SCHEMA IF EXISTS hotel CASCADE;
CREATE SCHEMA hotel;

CREATE DOMAIN hotel.tipo_cpf AS VARCHAR(11);

CREATE TABLE hotel.usuario(
	id_usuario SERIAL,
	nome_usuario VARCHAR(60) NOT NULL,
	senha VARCHAR(60) NOT NULL,
	CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
	CONSTRAINT uq_usuario UNIQUE (nome_usuario)
);

CREATE TABLE hotel.pessoa(
	cpf hotel.tipo_cpf,
	rg VARCHAR(16) NOT NULL,
	p_nome VARCHAR(255) NOT NULL,
	sobrenome VARCHAR(255) NOT NULL,
	data_nascimento DATE,
	rua VARCHAR(255) NOT NULL,
	cep VARCHAR(8) NOT NULL,
	CONSTRAINT pk_pessoa PRIMARY KEY (cpf),
	CONSTRAINT uq_pessoa UNIQUE (rg)
);

CREATE TABLE hotel.cliente(
	cod_cliente SERIAL,
	pessoa_cpf hotel.tipo_cpf UNIQUE,
	idade INT NOT NULL,
	data_cadastro DATE,
	CHECK (idade>=18),
	CONSTRAINT pk_cliente PRIMARY KEY (cod_cliente),
	CONSTRAINT fk_pessoa FOREIGN KEY (pessoa_cpf) REFERENCES hotel.pessoa(cpf)
	ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE hotel.email(
	id_email SERIAL,
	email VARCHAR(255) NOT NULL,
	pessoa_cpf hotel.tipo_cpf UNIQUE,
	CONSTRAINT pk_email PRIMARY KEY (id_email),
	CONSTRAINT fk_pessoa FOREIGN KEY (pessoa_cpf) REFERENCES hotel.pessoa(cpf)
	ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE hotel.telefone(
	id_telefone SERIAL,
	telefone VARCHAR(11) NOT NULL,
	pessoa_cpf hotel.tipo_cpf UNIQUE,
	CONSTRAINT pk_telefone PRIMARY KEY (id_telefone),
	CONSTRAINT fk_pessoa FOREIGN KEY (pessoa_cpf) REFERENCES hotel.pessoa(cpf)
	ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE hotel.dependentes(
	id_dependente SERIAL,
	cpf hotel.tipo_cpf,
	rg VARCHAR(16) NOT NULL,
	p_nome VARCHAR(255) NOT NULL,
	sobrenome VARCHAR(255) NOT NULL,
	data_nascimento DATE,
	cod_responsavel INT,
	CONSTRAINT pk_dependente PRIMARY KEY (rg),
	CONSTRAINT fk_cliente FOREIGN KEY (cod_responsavel) REFERENCES hotel.cliente(cod_cliente)
	ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE hotel.funcionario(
	mat_func SERIAL,
	salario FLOAT,
	data_contrato DATE,
	conta_bancaria VARCHAR(60) NOT NULL,
	pessoa_cpf hotel.tipo_cpf UNIQUE,
	CONSTRAINT pk_funcionario PRIMARY KEY (mat_func),
	CONSTRAINT fk_pessoa FOREIGN KEY (pessoa_cpf) REFERENCES hotel.pessoa(cpf)
	ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE hotel.funcao(
	nome VARCHAR(60),
	horario VARCHAR(60),
	CONSTRAINT pk_funcao PRIMARY KEY (nome)
);

CREATE TABLE hotel.responsavel(
	mat_func INT,
	funcao VARCHAR(60),
	CONSTRAINT fk_funcionario FOREIGN KEY (mat_func) REFERENCES hotel.funcionario(mat_func)
	ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT fk_funcao FOREIGN KEY (funcao) REFERENCES hotel.funcao(nome)
	ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE hotel.tipo(
	nome VARCHAR(60),
	capacidade INT NOT NULL,
	valor FLOAT,
	CONSTRAINT pk_tipo PRIMARY KEY (nome)
);

CREATE TABLE hotel.quarto(
	numero SERIAL,
	area INT NOT NULL,
	tipo VARCHAR(60),
	status VARCHAR(60) NOT NULL,
	CONSTRAINT pk_quarto PRIMARY KEY (numero),
	CONSTRAINT fk_tipo FOREIGN KEY (tipo) REFERENCES hotel.tipo(nome)
	ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE hotel.reserva(
	cod_cliente INT,
	tipo_quarto VARCHAR(60),
	CONSTRAINT fk_cliente FOREIGN KEY (cod_cliente) REFERENCES hotel.cliente(cod_cliente)
	ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT fk_tipo FOREIGN KEY (tipo_quarto) REFERENCES hotel.tipo(nome)
	ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE hotel.registro(
	num_registro SERIAL,
	checkin DATE,
	checkout DATE,
	status VARCHAR(60),
	forma_pagamento VARCHAR(60) DEFAULT 'Dinheiro',
	cod_cliente INT UNIQUE,
	mat_func INT,
	CONSTRAINT pk_registro PRIMARY KEY (num_registro),
	CONSTRAINT fk_cliente FOREIGN KEY (cod_cliente) REFERENCES hotel.cliente(cod_cliente)
	ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT fk_funcionario FOREIGN KEY (mat_func) REFERENCES hotel.funcionario(mat_func)
	ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE hotel.ocupa(
	num_registro INT UNIQUE,
	num_quarto INT UNIQUE,
	qtd_pessoas INT NOT NULL,
	CONSTRAINT fk_registro FOREIGN KEY (num_registro) REFERENCES hotel.registro(num_registro)
	ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT fk_quarto FOREIGN KEY (num_quarto) REFERENCES hotel.quarto(numero)
	ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE hotel.itens(
	cod_item SERIAL,
	nome VARCHAR(60) NOT NULL,
	valor FLOAT NOT NULL,
	descricao VARCHAR(100),
	tipo VARCHAR(60),
	CONSTRAINT pk_itens PRIMARY KEY (cod_item)
);

CREATE TABLE hotel.aloca(
	id_alocacao SERIAL,
	cod_item INT,
	mat_func INT,
	num_registro INT,
	quantidade INT,
	CONSTRAINT fk_itens FOREIGN KEY (cod_item) REFERENCES hotel.itens(cod_item)
	ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT fk_funcionario FOREIGN KEY (mat_func) REFERENCES hotel.funcionario(mat_func)
	ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT fk_registro FOREIGN KEY (num_registro) REFERENCES hotel.registro(num_registro)
	ON DELETE SET NULL ON UPDATE CASCADE
);

INSERT INTO hotel.usuario (nome_usuario,senha) VALUES
  ('brunnasilva','1234'),
  ('zkelvinfps','1234'),
  ('marielmarques','1234'),
  ('raul.s.vilar','1234');

INSERT INTO hotel.pessoa VALUES
  ('000000002','000000002','Bruna', 'Silva','01/01/1997', 'Rua A', '49000002'),
  ('000000003','000000003','Jonathan', 'Kelvin','01/01/1997', 'Rua B', '49000003'),
  ('000000005','000000005','Luiz', 'Mariel','01/01/1994', 'Rua C', '49000005'),
  ('000000007','000000007','Raul','Vilar','01/01/1995', 'Rua D', '49000007'),
  ('000000012','000000012','Func1', 'Hotel','01/01/1990', 'Rua A', '49000012'),
  ('000000013','000000013','Func2', 'Hotel','01/01/1990', 'Rua B', '49000013'),
  ('000000015','000000015','Func3', 'Hotel','01/01/1990', 'Rua C', '49000015'),
  ('000000017','000000017','Func4','Hotel','01/01/1990', 'Rua D', '49000017'),
  ('000000019','000000019','Func5','Hotel','01/01/1990', 'Rua E', '49000019');

INSERT INTO hotel.cliente (pessoa_cpf,idade,data_cadastro) VALUES
  ('000000002','21','03/09/2018'),
  ('000000003','20','03/09/2018'),
  ('000000005','23','03/09/2018'),
  ('000000007','22','03/09/2018');

INSERT INTO hotel.email (email,pessoa_cpf) VALUES
  ('bruna.silva@dcomp.ufs.br','000000002'),
  ('jonathan.santos@dcomp.ufs.br','000000003'),
  ('mariel.marques@dcomp.ufs.br','000000005'),
  ('raul.vilar@dcomp.ufs.br','000000007'),
  ('func1@maishotel.br','000000012'),
  ('func2@maishotel.br','000000013'),
  ('func3@maishotel.br','000000015'),
  ('func4@maishotel.br','000000017'),
  ('func5@maishotel.br','000000019');

INSERT INTO hotel.telefone(telefone,pessoa_cpf) VALUES
  ('99999999999','000000002'),
  ('99999999999','000000003'),
  ('99999999999','000000005'),
  ('99999999999','000000007'),
  ('99999999999','000000012'),
  ('99999999999','000000013'),
  ('99999999999','000000015'),
  ('99999999999','000000017'),
  ('99999999999','000000019');

INSERT INTO hotel.dependentes(cpf,rg,p_nome,sobrenome,data_nascimento,cod_responsavel) VALUES
  ('','10000000','Im','Dependente1','23/02/2007','1'),
  ('','20000000','Im','Dependente2','29/05/2006','1'),
  ('','30000000','Im','Dependente3','29/05/2008','3'),
  ('','40000000','Im','Dependente4','29/05/2010','4');

INSERT INTO hotel.funcionario(salario,data_contrato,conta_bancaria,pessoa_cpf) VALUES
  (1500.5,'23/02/2007','20000001','000000012'),
  (1500.5,'29/05/2010','20000002','000000013'),
  (1700,'29/05/2006','20000003','000000015'),
  (1750.7,'29/05/2008','20000004','000000017'),
  (1650.1,'29/05/2010','20000005','000000019');

INSERT INTO hotel.funcao VALUES
  ('Recepcionista','12-12'),
  ('Gerente','8-22'),
  ('Zelador','7-22'),
  ('Seguranca','12-12'),
  ('Comandante','8-20');

INSERT INTO hotel.responsavel VALUES
  ('1','Recepcionista'),
  ('2','Gerente'),
  ('3','Zelador'),
  ('4','Seguranca'),
  ('5','Comandante');

INSERT INTO hotel.tipo VALUES
  ('Simples',2,400),
  ('Normal',3,600),
  ('Top',4,750),
  ('Mais',4,1000);

INSERT INTO hotel.quarto(area,tipo,status) VALUES
  (1,'Simples','Ocupado'),
  (1,'Normal','Ocupado'),
  (1,'Simples','Disponivel'),
  (2,'Mais','Limpeza')
  (10,'Top', 'Disponivel');

INSERT INTO hotel.reserva VALUES
  (1,'Simples'),
  (4,'Normal'),
  (2,'Mais');

INSERT INTO hotel.registro(checkin,checkout,status,cod_cliente,mat_func) VALUES
  ('29/05/2018','06/06/2018','Ocupado',1,1),
  ('29/05/2018','06/06/2018','Ocupado',4,1),
  ('29/05/2018','02/06/2018','Fechado',3,1),
  ('29/05/2018','05/06/2018','Fechado',2,1);

INSERT INTO hotel.ocupa VALUES
  (1,1,1),
  (2,2,2),
  (3,3,2),
  (4,4,2);

INSERT INTO hotel.itens(nome,valor,descricao,tipo) VALUES
  ('Serenata do Amor',2.5,'Chocolate do amor','lanche'),
  ('Sonho de Valsa',2.5,'Chocolate dancante','lanche'),
  ('Agua Mineral',3,'Agua doce','bebida'),
  ('Guarana',3.5,'O melhor que há','bebida');

INSERT INTO hotel.aloca(cod_item,mat_func,num_registro,quantidade) VALUES
  (1,5,1,4),
  (2,5,3,2),
  (3,5,2,1),
  (1,5,2,2),
  (4,5,2,1);
