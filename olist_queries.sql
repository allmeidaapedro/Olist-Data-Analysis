-- 1. Quantos clientes únicos existem no banco de dados?

SELECT COUNT(DISTINCT(customer_unique_id))
FROM olist.customers 
-- Há 96096 clientes.

-- 2. Quantos pedidos foram feitos?

SELECT COUNT(DISTINCT(order_id))
FROM olist.orders
-- 99441 pedidos foram feitos.

-- 3. Qual foi a receita total?
SELECT SUM(payment_value)
FROM olist.payments
-- A receita total foi de 16 milhões de reais.

-- 4. Quais são as 5 cidades com mais pedidos?

SELECT 
	LOWER(c.customer_city), 
	COUNT(o.order_id) as numero_pedidos
FROM olist.orders AS o
LEFT JOIN olist.customers AS c
ON o.customer_id = c.customer_id
WHERE c.customer_city IS NOT NULL
GROUP BY LOWER(c.customer_city)
ORDER BY numero_pedidos DESC
-- As 5 cidades com mais pedidos são:
	-- São Paulo = 15540
	-- Rio de Janeiro = 6882
	-- Belo Horizonte = 2773
	-- Brasília = 2131
	-- Curitiba = 1521
	
-- 5. Quantos pedidos foram entregues em cada estado? 
-- Quais os estados com maior e menor número de pedidos?

-- a. Checando se os estados estão com as siglas corretas.
SELECT DISTINCT(customer_state)
FROM olist.customers

-- b. Checando os status de pedido e as quantidades. 
SELECT 
	order_status,
	COUNT(order_status),
	ROUND((COUNT(order_status) * 100.0) / (SELECT COUNT(*) FROM olist.orders), 2) AS percentage
FROM olist.orders
GROUP BY order_status
-- 97% dos pedidos foram entregues, totalizando 96478 pedidos. Agora, vamos analisar por estado.

SELECT 
	c.customer_state,
	COUNT(o.order_id) as numero_pedidos
FROM olist.orders AS o
LEFT JOIN olist.customers AS c
ON o.customer_id = c.customer_id
WHERE o.order_status = 'delivered'
GROUP BY c.customer_state
ORDER BY numero_pedidos DESC

-- d. Da mesma forma, SP, RJ, MG, RS e PR são os estados com o maior número de pedidos.
-- Com destaque para SP, liderando disparado o primeiro lugar, com 40501 pedidos totais.

-- 6. Qual é o valor médio de pagamento por pedido?

-- Obtendo a soma do valor pago para cada pedido único.
WITH pedidos_unicos AS(
	SELECT 
		order_id,
		SUM(payment_value) as total_pago_pedido
	FROM olist.payments
	GROUP BY order_id
)

SELECT AVG(total_pago_pedido)
FROM pedidos_unicos
-- O valor médio pago por pedido é de 161 reais.

-- 7. Quais categorias de produto têm o menor e o maior volume de vendas? 
-- a. Analisando as diferentes categorias possíveis.
SELECT 
	DISTINCT(product_category_name)
FROM olist.products

-- b. Top 5 produtos com maior volume de vendas.
SELECT 
	p.product_category_name,
	COUNT(i.order_id) as volume_vendas
FROM olist.items as i
LEFT JOIN olist.products as p
ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY volume_vendas DESC
LIMIT 5

-- c. Top 5 produtos com menor volume de vendas.
SELECT 
	p.product_category_name,
	COUNT(i.order_id) as volume_vendas
FROM olist.items as i
LEFT JOIN olist.products as p
ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY volume_vendas ASC
LIMIT 5

-- As top 5 categorias com maior número de pedidos são cama_mesa_banho, 
-- beleza_saude, esporte_lazer, moveis_decoracao, informatica_acessorios.
-- As top 5 categorias com menor número de pedidos são seguros_e_servicos,
-- fashion_roupa_infanto_juvenil, pc_gamer, la_cuisine, cds_dvds_musicais.

-- 8. Quantos vendedores existem em cada estado?

SELECT
	seller_state,
	COUNT(seller_id) as numero_vendedores
FROM olist.sellers
GROUP BY seller_state
ORDER BY numero_vendedores DESC
-- SP, PR, MG, SC e RJ são os 5 estados com maior número de vendedores. Com destaque para
-- SP. Estados do norte e nordeste são os com menor número, vários, como MA, AC, PI, AM e PA
-- possuem apenas um único vendedor.

-- 9. Quantos clientes existem em cada estado?
SELECT
	customer_state, 
	COUNT(customer_unique_id) as numero_clientes
FROM olist.customers
GROUP BY customer_state
ORDER BY numero_clientes DESC
-- Semelhantemente aos vendedores, se dão os estados dos clientes.

-- 10. Qual é a avaliação média dos clientes?
SELECT
	AVG(r.review_score)
FROM olist.orders AS o
LEFT JOIN olist.reviews AS r
ON o.order_id = r.order_id
-- A avaliação média é de aproximadamente 4 de 5 estrelas.






