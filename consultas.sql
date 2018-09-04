-- Lista as informações dos clientes maiores de 20 anos

SELECT 
    *
FROM
    hotel.cliente c
WHERE
    c.idade > 20

-- Listando funcionarios, com salarios maiores que 1600, por nome, cpf, salario e funcao

SELECT
    p.p_nome, p.sobrenome, p.cpf, f.salario, r.funcao
FROM
    hotel.funcionario f
    JOIN hotel.pessoa p
        ON(f.pessoa_cpf=p.cpf)
    NATURAL JOIN
        hotel.responsavel r
WHERE (salario>1600);

-- Listando clientes com reservas por nome, telefone, email e tipo de quarto
SELECT
    p.p_nome, p.sobrenome, t.telefone, e.email, sq.tipo_quarto
FROM
    hotel.pessoa p
    JOIN 
        hotel.email e 
        ON(pessoa_cpf=cpf)
    JOIN
        hotel.telefone t
        USING(pessoa_cpf)
    JOIN
        (SELECT
            c.cod_cliente, pessoa_cpf, r.tipo_quarto
        FROM hotel.cliente c 
            JOIN hotel.reserva r
                USING(cod_cliente))  AS sq 
        USING (pessoa_cpf);

-- Listando  AS informações do cliente mais velho
SELECT
    *
FROM
    hotel.pessoa p 
WHERE
    p.data_nascimento = (
                        SELECT 
                            min(data_nascimento)
                        FROM
                            hotel.pessoa p1 
                            JOIN hotel.cliente c
                                ON(p1.cpf=c.pessoa_cpf));

-- Listando nome e email das pessoas com email do dcomp
SELECT
    p_nome, sobrenome, email
FROM
    hotel.pessoa p1 
    JOIN 
        hotel.email e
        ON(p1.cpf=e.pessoa_cpf) 
WHERE
    email like '%dcomp.ufs.br';

-- Listando nome dos dependentes e seus responsaveis
SELECT
    d.p_nome, d.sobrenome, cod_responsavel, sq.p_nome, sq.sobrenome
FROM
    hotel.dependentes d
    JOIN (
        SELECT
            p_nome, cod_cliente, sobrenome
        FROM
            hotel.pessoa p
            JOIN hotel.cliente c
            ON(p.cpf=c.pessoa_cpf))
        as sq ON(sq.cod_cliente=d.cod_responsavel)
ORDER BY d.sobrenome;

-- Listando clientes em ordem de maior gasto em itens
SELECT
    p_nome, sobrenome, sq.num_registro, sq.s
FROM
    hotel.pessoa 
    JOIN
        hotel.cliente
        ON (cpf=pessoa_cpf)
        JOIN
            hotel.registro
            USING(cod_cliente)
            NATURAL JOIN 
                (SELECT
                    a.num_registro, sum(i.valor*a.quantidade) s
                FROM
                    hotel.itens i
                    JOIN
                        hotel.aloca a
                        USING(cod_item)
                GROUP BY
                    a.num_registro) AS sq
ORDER BY s desc;

-- Lista os clientes que compraram mais que a média

SELECT
	p_nome, sobrenome, num_registro, sum(i.valor*a.quantidade) valor_items
FROM
    hotel.pessoa 
    JOIN
        hotel.cliente
        ON (cpf=pessoa_cpf)
        JOIN
            hotel.registro
            USING(cod_cliente)
            JOIN 
				hotel.aloca a
				USING(num_registro)
				JOIN
					hotel.itens i
                    USING(cod_item)
GROUP BY
	num_registro,
	pessoa.p_nome,
	sobrenome
HAVING
	sum(i.valor*a.quantidade) > (
					SELECT
						AVG(tb1.valor_items)
					FROM
						(SELECT
							p_nome, sobrenome, num_registro, sum(i.valor*a.quantidade) as valor_items
						FROM
							hotel.pessoa 
							JOIN
								hotel.cliente
								ON (cpf=pessoa_cpf)
								JOIN
									hotel.registro
									USING(cod_cliente)
									JOIN 
										hotel.aloca a
										USING(num_registro)
										JOIN
											hotel.itens i
											USING(cod_item)
						GROUP BY
							num_registro,
							pessoa.p_nome,
							sobrenome) as tb1)

-- Lista o total em R$ de entrada
SELECT
    (sum(i.valor*a.quantidade) + sum(t.valor)) AS entradas
FROM
    hotel.aloca a
    NATURAL JOIN
        hotel.itens i
        JOIN
          hotel.registro r 
          USING(num_registro)
          JOIN
            hotel.ocupa o 
            USING(num_registro)
            JOIN
                hotel.quarto q
                ON (o.num_quarto=q.numero)
                JOIN
                  hotel.tipo t
                  ON (q.tipo=t.nome);
-- Gera a fatura do cliente somando os consumos mais as diárias
SELECT
	p_nome, sobrenome, num_registro, valor_items_comprados+(extract(day from age( hotel.registro.checkout, hotel.registro.checkin))*valor_quarto) as fatura
FROM
    hotel.pessoa 
    JOIN
        hotel.cliente
        ON (cpf=pessoa_cpf)
        JOIN
            hotel.registro
            USING(cod_cliente)
            JOIN
				(SELECT
				 	num_registro,
					SUM(i.valor*a.quantidade) as valor_items_comprados
				FROM
					hotel.aloca a
				 	JOIN
				 		hotel.registro
					USING(num_registro)
					JOIN
						hotel.itens i
                    	USING(cod_item)
				GROUP BY
					num_registro) AS items_comprados
				USING(num_registro)
				JOIN
					(SELECT
					 	num_registro,
						sum(ti.valor) as valor_quarto
					FROM
						hotel.ocupa
						JOIN
					 		hotel.registro
							USING(num_registro)
							JOIN
								hotel.quarto
								ON (hotel.ocupa.num_quarto = hotel.quarto.numero)
								JOIN
									hotel.tipo as ti
									ON ti.nome = hotel.quarto.tipo
					GROUP BY
					num_registro) AS quartos_comprados
					USING(num_registro)
