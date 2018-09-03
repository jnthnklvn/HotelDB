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
