/*Listando funcionarios, com salarios maiores que 1600, por nome, cpf, salario e funcao*/
select p.p_nome, p.sobrenome, p.cpf, f.salario, r.funcao from
hotel.funcionario f join hotel.pessoa p on(f.pessoa_cpf=p.cpf)
natural join hotel.responsavel r where (salario>1600);

/*Listando clientes com reservas por nome, telefone, email e tipo de quarto*/
select p.p_nome, p.sobrenome, t.telefone, e.email, sq.tipo_quarto
from hotel.pessoa p join hotel.email e on(pessoa_cpf=cpf)
join hotel.telefone t using(pessoa_cpf) join
(select c.cod_cliente, pessoa_cpf, r.tipo_quarto from hotel.cliente c 
join hotel.reserva r using(cod_cliente)) as sq using (pessoa_cpf);

/*Listando as informações do cliente mais velho*/
select * from hotel.pessoa p where p.data_nascimento = 
(select min(data_nascimento) from hotel.pessoa p1 
join hotel.cliente c on(p1.cpf=c.pessoa_cpf));

/*Listando nome e email das pessoas com email do dcomp*/
select p_nome, sobrenome, email from hotel.pessoa p1 
join hotel.email e on(p1.cpf=e.pessoa_cpf) 
where email like '%dcomp.ufs.br';

/*Listando nome dos dependentes e seus responsaveis*/
select d.p_nome, d.sobrenome, cod_responsavel, sq.p_nome, sq.sobrenome
from hotel.dependentes d join (select p_nome, cod_cliente, sobrenome
from hotel.pessoa p join hotel.cliente c on(p.cpf=c.pessoa_cpf))
as sq on(sq.cod_cliente=d.cod_responsavel) order by d.sobrenome;

/*Listando clientes em ordem de maior gasto em itens*/
select p_nome, sobrenome, sq.num_registro, sq.s from hotel.pessoa 
join hotel.cliente on (cpf=pessoa_cpf) join hotel.registro using(cod_cliente)
natural join (select a.num_registro, sum(i.valor*a.quantidade) s from hotel.itens i
join hotel.aloca a using(cod_item) group by a.num_registro) as sq order by s desc;

/*Lista o total em R$ de entrada*/
select (sum(i.valor*a.quantidade) + sum(t.valor)) as entradas from hotel.aloca a natural join
hotel.itens i join hotel.registro r using(num_registro) join hotel.ocupa o using(num_registro) join
hotel.quarto q on(o.num_quarto=q.numero) join hotel.tipo t on(q.tipo=t.nome);
