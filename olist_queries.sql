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

-- 11. Qual é o valor médio do frete por pedido?
-- OBS: order_item_id não representa o número de itens em uma ordem, mas sim
-- um identificador único para cada item dentro de um mesmo pedido. Por exemplo,
-- o cliente pode pedir, em uma mesma order, 3 itens. Essa ordem aparecerá 3 vezes
-- nos dados, com item_id 1 pra sequência de itens 1, 2 e 3.
WITH sum_freight_per_order AS (
	SELECT
		order_id,
		SUM(freight_value) as sum_freight
	FROM olist.items
	GROUP BY order_id
)

SELECT
	AVG(sum_freight)
FROM sum_freight_per_order
-- O frete médio pago por pedido é de aproximadamente 23 reais.


-- 12. Quantos pedidos foram entregues com atraso?
SELECT
	COUNT(*)
FROM olist.orders
WHERE to_char(order_delivered_customer_date, 'YYYY-MM-DD') > to_char(order_estimated_delivery_date, 'YYYY-MM-DD')
-- Apenas 6535 pedidos foram entregues com atraso.

-- 13. Quais são os tipos de pagamento mais comuns?
SELECT 
	payment_type,
	COUNT(payment_type) AS contagem,
	ROUND((COUNT(payment_type) * 100.0 / (SELECT COUNT(*) FROM olist.payments)), 2) AS percentual
FROM olist.payments
GROUP BY payment_type
ORDER BY percentual DESC
-- Cartão de crédito e boleto são os tipos de pagamento mais comuns, representando 74% e 19%
-- do total de pagamentos, respectivamente.

-- 14. Qual é o número médio de parcelas por pagamento?
SELECT
	AVG(payment_installments)
FROM olist.payments
-- Em média, os clientes dividem o pagamento em aproximadamente 3 parcelas.

-- 15. Quantos pedidos têm múltiplos itens?
WITH multiple_items_orders AS (
    SELECT 
        order_id,
        COUNT(order_id)
    FROM olist.items
    GROUP BY order_id
    HAVING COUNT(order_id) > 1
)

SELECT 
    COUNT(order_id) as pedidos_com_multiplos_itens,
    ROUND((COUNT(order_id) * 100.0) / (SELECT COUNT(DISTINCT(order_id)) FROM olist.items), 2) as percentage
FROM multiple_items_orders;
-- Apenas 9803 pedidos têm múltiplos itens. Isso representa aproximadamente 10% do
-- total de pedidos.

-- 16. Como a pontuação de avaliação varia por categoria de produto?
-- Top 5 categorias de produto com maior review score médio.
SELECT
	p.product_category_name,
	AVG(r.review_score) as pontuacao_media
FROM olist.items AS i
LEFT JOIN olist.reviews AS r
ON i.order_id = r.order_id
LEFT JOIN olist.products AS p
ON p.product_id = i.product_id
GROUP BY p.product_category_name
ORDER BY pontuacao_media DESC
LIMIT 5

-- Top 5 categorias de produto com maior review score médio:
	-- cds_dvds_musicais.
	-- fashion_roupa_infanto_juvenil.
	-- livros_interesse_geral.
	-- construcao_ferramentas.
	-- flores.

SELECT
	p.product_category_name,
	AVG(r.review_score) as pontuacao_media
FROM olist.items AS i
LEFT JOIN olist.reviews AS r
ON i.order_id = r.order_id
LEFT JOIN olist.products AS p
ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY pontuacao_media ASC
LIMIT 5

-- Top 5 categorias com menor review_score médio
	-- seguros_e_servicos.
	-- fraldas_higiene.
	-- portateis_cozinha_e_preparadores_de_alimentos.
	-- pc_gamer.
	-- moveis_escritorio.

-- 17. Qual é a tendência do número de pedidos ao longo dos anos?
SELECT 
	to_char(order_purchase_timestamp, 'YYYY-MM') AS year_month,
	COUNT(order_id)
FROM olist.orders
GROUP BY year_month
ORDER BY year_month
-- No geral, há uma tendência de crescimento. Especialmente, em novembro de 2017,
-- há um pico. Provavelmente por conta da black friday.

-- 18. Qual é a tendência do número de pedidos ao longo dos meses?/Qual 
-- é o mês com o maior número de pedidos?

SELECT
	CASE 
		 WHEN to_char(order_purchase_timestamp, 'MM') = '01' THEN 'JAN'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '02' THEN 'FEV'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '03' THEN 'MAR'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '04' THEN 'ABR'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '05' THEN 'MAI'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '06' THEN 'JUN'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '07' THEN 'JUL'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '08' THEN 'AGO'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '09' THEN 'SET'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '10' THEN 'OUT'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '11' THEN 'NOV'
	ELSE 'DEZ'
	END AS mes,
	COUNT(order_id)
FROM olist.orders
GROUP BY mes, to_char(order_purchase_timestamp, 'MM')
ORDER BY to_char(order_purchase_timestamp, 'MM') ASC

-- Os melhores meses, no geral, são Maio, Julho e Agosto. Enquanto os piores são Setembro 
-- e Outubro. O mês com o maior número de vendas é Agosto.

-- 19. Qual é a tendência do número de pedidos ao longo da semana?
SELECT
	CASE
		WHEN EXTRACT(ISODOW FROM order_purchase_timestamp) = 1 THEN 'Seg'
		WHEN EXTRACT(ISODOW FROM order_purchase_timestamp) = 2 THEN 'Ter'
		WHEN EXTRACT(ISODOW FROM order_purchase_timestamp) = 3 THEN 'Qua'
		WHEN EXTRACT(ISODOW FROM order_purchase_timestamp) = 4 THEN 'Qui'
		WHEN EXTRACT(ISODOW FROM order_purchase_timestamp) = 5 THEN 'Sex'
		WHEN EXTRACT(ISODOW FROM order_purchase_timestamp) = 6 THEN 'Sab'
	ELSE
		'Dom'
	END AS dia,
	COUNT(order_id)
FROM olist.orders
GROUP BY dia, EXTRACT(ISODOW FROM order_purchase_timestamp)
ORDER BY EXTRACT(ISODOW FROM order_purchase_timestamp)
-- No geral, as vendas tendem a cair ao longo da semana. O melhor dia é segunda-feira,
-- enquanto o pior é sábado.

-- 20. Qual é a tendência do número de pedidos ao longo do dia?
SELECT
	EXTRACT(HOUR FROM order_purchase_timestamp) AS hour,
	COUNT(order_id)
FROM olist.orders
GROUP BY hour
ORDER BY hour
-- No geral, as vendas tendem a ser maiores durante a tarde. Temos um pico às 16.

-- 21. Qual é o mês com a maior receita?
SELECT
	CASE 
		 WHEN to_char(order_purchase_timestamp, 'MM') = '01' THEN 'JAN'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '02' THEN 'FEV'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '03' THEN 'MAR'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '04' THEN 'ABR'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '05' THEN 'MAI'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '06' THEN 'JUN'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '07' THEN 'JUL'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '08' THEN 'AGO'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '09' THEN 'SET'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '10' THEN 'OUT'
		 WHEN to_char(order_purchase_timestamp, 'MM') = '11' THEN 'NOV'
	ELSE 'DEZ'
	END AS mes,
	SUM(p.payment_value)
FROM olist.orders AS o
LEFT JOIN olist.payments AS p
ON o.order_id = p.order_id
GROUP BY mes, to_char(order_purchase_timestamp, 'MM')
ORDER BY to_char(order_purchase_timestamp, 'MM') 
-- Agosto é também o mês com maior receita, totalizando 1.69 milhões de reais.

-- 22. Qual é o tempo médio de entrega para pedidos em cada estado?
-- Tabela com tempode entrega
WITH tempo_entrega AS(
	SELECT
		customer_id,
		EXTRACT(EPOCH FROM (order_delivered_customer_date - order_approved_at) / 86400) AS tempo_entrega
	FROM olist.orders
)

SELECT
	c.customer_state,
	AVG(t.tempo_entrega) as tempo_entrega_medio
FROM tempo_entrega AS t
LEFT JOIN olist.customers AS c
ON t.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY tempo_entrega_medio
-- SP é o estado com o menor tempo de entrega médio, em torno de 8 dias. Roraima é o
-- estado com maior tempo de entrega médio, em torno de 29 dias.

-- 23. Quantos pedidos foram cancelados?
SELECT
	order_status,
	COUNT(*)
FROM olist.orders
WHERE order_status = 'canceled'
GROUP BY order_status
-- 625 pedidos foram cancelados.

-- 24. Qual é o valor médio pago por categoria de produto? Quais são as categorias
-- mais caras e mais baratas?
SELECT
	prod.product_category_name,
	AVG(py.payment_value) as valor_medio_pago
FROM olist.items AS i
LEFT JOIN olist.payments AS py
ON i.order_id = py.order_id
LEFT JOIN olist.products AS prod
ON i.product_id = prod.product_id
GROUP BY prod.product_category_name
ORDER BY valor_medio_pago DESC

SELECT
	p.product_category_name,
	AVG(i.price) as preco_medio
FROM olist.items AS i
LEFT JOIN olist.products AS p
ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY preco_medio DESC
-- Pcs, portáteis e produtos para agro, indústria e comércio estão entre os mais caros e
-- com maior valor pago.

-- 25. Qual vendedor tem o maior valor médio de pedido?
SELECT
	i.seller_id,
	AVG(payment_value) as valor_medio_pago
FROM olist.items AS i
LEFT JOIN olist.payments AS p
ON i.order_id = p.order_id
GROUP BY seller_id
ORDER BY valor_medio_pago DESC
LIMIT 5

-- 26. Qual é o número médio de dias entre a aprovação do pedido e a entrega?
SELECT
	AVG(EXTRACT(EPOCH FROM (order_delivered_customer_date - order_approved_at)) / 86400) AS avg_days_delivery
FROM olist.orders
-- Em média, tem-se 12 dias entre a aprovação do pedido e a entrega?

-- 27. Qual é o valor médio do pedido para pedidos com pontuações de avaliação de 1, 2, 3, 4 e 5?
SELECT
	AVG(i.price + i.freight_value) as valor_medio_pedido
FROM olist.items AS i
INNER JOIN olist.reviews AS r
ON i.order_id = r.order_id
GROUP BY r.review_score
-- Review score:
	-- 1. 148.5
	-- 2. 136.8
	-- 3. 130.34
	-- 4. 138.65
	-- 5. 140.8
	
-- 28. Qual é o número médio de produtos por pedido?
WITH produtos_por_pedido AS(
	SELECT
		order_id,
		COUNT(*) AS n_produtos
	FROM olist.items
	GROUP BY order_id
)

SELECT
	AVG(n_produtos) 
FROM produtos_por_pedido
-- O número médio de produtos por pedido é de aproximadamente 1.14.

-- 29. Quantos pedidos foram entregues antes da data de entrega estimada?
SELECT
	COUNT(*) AS pedidos_entregues,
	ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM olist.orders), 2)
FROM olist.orders
WHERE order_delivered_customer_date < order_estimated_delivery_date
-- 88649 pedidos foram entregues antes da data de entrega estimada. Isso representa
-- quase 90% dos pedidos.

-- 30. Quantos pedidos foram entregues até a data de entrega estimada?
SELECT
	COUNT(*) AS pedidos_entregues,
	ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM olist.orders), 2)
FROM olist.orders
WHERE to_char(order_delivered_customer_date, 'YYYY-MM-DD') <= to_char(order_estimated_delivery_date, 'YYYY-MM-DD')
-- 89941 pedidos foram entregues até a data de entrega e,stimada, compondo 90,45% de todos
-- os pedidos.
SELECT
	COUNT(*) AS pedidos_entregues,
	ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM olist.orders), 2)
FROM olist.orders
WHERE to_char(order_delivered_customer_date, 'YYYY-MM-DD') = to_char(order_estimated_delivery_date, 'YYYY-MM-DD')

-- 1292 foram entregues exatamente na data estimada.

-- 31. Qual é o valor médio de pagamento para pedidos com diferentes tipos de pagamento?
SELECT
	payment_type,
	AVG(payment_value) AS valor_medio
FROM olist.payments
GROUP BY payment_type
ORDER BY valor_medio DESC
-- Catão de crédito é o tipo de pagamento com maior valor médio pago.

-- 32. Quais são as 5 categorias de produtos mais lucrativas, 
-- suas pontuações médias de avaliação e o estado que as compra mais?
-- a. Estados que mais compram as 5 categorias mais lucrativas.
WITH products_states_count AS (
	SELECT 
		p.product_category_name,
		c.customer_state,
		COUNT(*) AS pedidos_estado
	FROM olist.items AS i
	LEFT JOIN olist.products AS p
	ON i.product_id = p.product_id
	LEFT JOIN olist.orders AS o
	ON i.order_id = o.order_id
	LEFT JOIN olist.customers AS c
	ON o.customer_id = c.customer_id
	WHERE p.product_category_name IN ('beleza_saude', 
									 'relogios_presentes',
									 'cama_mesa_banho',
									 'esporte_lazer',
									 'informatica_acessorios')
	GROUP BY p.product_category_name, c.customer_state
	ORDER BY p.product_category_name, c.customer_state
)

SELECT 
	product_category_name,
	customer_state,
	pedidos_estado
FROM (
    SELECT 
        *,
        RANK() OVER (PARTITION BY product_category_name ORDER BY pedidos_estado DESC) AS rank_state
    FROM products_states_count
) AS ranked_states
WHERE rank_state = 1;
-- Para todos os produtos, SP é o estado onde eles são mais vendidos.

-- b. Top 5 produtos mais lucrativas e seus review scores médios.
SELECT
	p.product_category_name,
	SUM(i.price + i.freight_value) AS receita_total,
	AVG(r.review_score) AS pontuacao_media
FROM olist.items AS i
LEFT JOIN olist.products AS p
ON i.product_id = p.product_id
LEFT JOIN olist.reviews AS r
ON i.order_id = r.order_id
GROUP BY p.product_category_name
ORDER BY receita_total DESC
LIMIT 5
-- As 5 categorias de produto mais lucrativas são:
	-- 1. Beleza e saúde.
	-- 2. Relógios e presentes.
	-- 3. Cama, mesa e banho.
	-- 4. Esporte e lazer.
	-- 5. Informática e acessórios.
-- Essas categorias possuem pontuação média de 3.9 a 4.15

-- 33. Que insights podem ser tirados da relação entre a localização do vendedor e a localização do cliente em relação às entregas atrasadas?
-- a. Analisando entregas atrasadas por estado
SELECT
	c.customer_state,
	COUNT(*) AS pedidos_atrasados
FROM olist.orders AS o
LEFT JOIN olist.customers AS c
ON o.customer_id = c.customer_id
WHERE to_char(o.order_delivered_customer_date, 'YYYY-MM-DD') > to_char(o.order_estimated_delivery_date, 'YYYY-MM-DD')
GROUP BY c.customer_state
ORDER BY pedidos_atrasados DESC
-- SP e RJ lideram, com o maior número de pedidos atrasados.

-- b. Analisando distância entre cliente e vendedor e entrega atrasada ou não.
-- Obter a latitude e longitude média por zip_code de cliente e vendedor, pois
-- há várias latitudes e longitudes para um mesmo zip code.
-- CREATE EXTENSION IF NOT EXISTS postgis;
-- OBS: PROBLEMAS PARA INSTALAR O PACOTE QUE PERMITE CÁLCULOS DE DISTÂNCIA NO POSTGRESQL: POSTGIS
WITH lat_lng_cust AS(
	SELECT
		c.customer_id,
		AVG(g.geolocation_lat) AS lat_media,
		AVG(g.geolocation_lng) AS lng_media
	FROM olist.geolocation AS g
	INNER JOIN olist.customers AS c
	ON g.geolocation_zip_code_prefix = c.customer_zip_code_prefix
	GROUP BY g.geolocation_zip_code_prefix, c.customer_id
)
, lat_lng_sel AS(
	SELECT
		s.seller_id,
		AVG(g.geolocation_lat) AS lat_media,
		AVG(g.geolocation_lng) AS lng_media
	FROM olist.geolocation AS g
	INNER JOIN olist.sellers AS s
	ON g.geolocation_zip_code_prefix = s.seller_zip_code_prefix
	GROUP BY g.geolocation_zip_code_prefix, s.seller_id
)

SELECT
    *
FROM olist.items AS i
LEFT JOIN olist.orders AS o
ON i.order_id = o.order_id
LEFT JOIN olist.customers AS c
ON o.customer_id = c.customer_id
LEFT JOIN olist.sellers AS s
ON i.seller_id = s.seller_id
LEFT JOIN lat_lng_cust AS lc
ON o.customer_id = lc.customer_id
LEFT JOIN lat_lng_sel AS ls
ON i.seller_id = ls.seller_id
LIMIT 5


-- 34. Existe correlação entre o número de parcelas de pagamento e a pontuação de avaliação?
SELECT
	CORR(p.payment_installments, r.review_score) 
FROM olist.payments AS p
INNER JOIN olist.reviews AS r
ON p.order_id = r.order_id
-- Não há correlação significativa.

-- Existe correlação entre o review score e o preço do item/frete?
SELECT
	CORR(i.freight_value, r.review_score)
FROM olist.items AS i
LEFT JOIN olist.reviews AS r
ON i.order_id = r.order_id
-- Também não.

-- 35. Como os tempos de entrega variam entre diferentes categorias de produtos?
-- Top 5 categorias de produto com menor tempo médio de entrega.
SELECT
	p.product_category_name,
	AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_approved_at)) / 86400) AS tempo_medio_entrega
FROM olist.items AS i
LEFT JOIN olist.orders AS o
ON i.order_id = o.order_id
LEFT JOIN olist.products AS p
ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY tempo_medio_entrega ASC
LIMIT 5
-- A categoria com o menor tempo de entrega é artes e artesanato. Em média, 5 dias.

-- Top 5 categorias de produto com maior tempo médio de entrega.
SELECT
	p.product_category_name,
	AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_approved_at)) / 86400) AS tempo_medio_entrega
FROM olist.items AS i
LEFT JOIN olist.orders AS o
ON i.order_id = o.order_id
LEFT JOIN olist.products AS p
ON i.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY tempo_medio_entrega DESC
LIMIT 5
-- A categoria com o maior tempo de entrega é móveis e escritório. Em média, 20 dias.
-- Fashion calçados, seguros e serviços, e casa e conforto estão incluídos na lista.
-- Seguros e serviços e móveis e escritório estão entre as top 5 categorias com menor
-- review score médio. Isso provavelmente está relacionado a essa demora de entrega
-- e ilustra como o tempo de entrega é algo relevante na satisfação do consumidor.

-- 36. Existe correlação entre o tempo de entrega e a pontuação de avaliação?
SELECT 
	CORR(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_approved_at) / 86400), r.review_score)
FROM olist.items AS i
LEFT JOIN olist.orders AS o
ON i.order_id = o.order_id
LEFT JOIN olist.reviews AS r
ON i.order_id = r.order_id
-- Existe uma correlação negativa moderada (-0.3) entre o tempo de entrega e o review score.
-- Isso indica que, quanto maior o tempo de entrega, menor o review score, e vice versa.

-- 37. Existem tendências observáveis nas pontuações de avaliação?
SELECT
	to_char(o.order_purchase_timestamp, 'YYYY-MM') AS year_month,
	COUNT(*) AS numero_pedidos,
	AVG(r.review_score) AS review_score_medio
FROM olist.items AS i
LEFT JOIN olist.orders AS o
ON i.order_id = o.order_id
LEFT JOIN olist.reviews AS r
ON i.order_id = r.order_id
GROUP BY year_month
ORDER BY year_month
-- O review score médio tende a manter-se em torno de 4 ao longo dos anos. A menor
-- pontuação média foi em março de 2018, com 3.69.

-- 38. Como o valor médio do pedido muda durante as temporadas de compras de pico?
SELECT 
	to_char(o.order_purchase_timestamp, 'YYYY-MM') AS year_month,
	AVG(i.price + i.freight_value) as valor_medio_pedido
FROM olist.items AS i
LEFT JOIN olist.orders AS o
ON i.order_id = o.order_id
GROUP BY year_month
ORDER BY year_month
-- Não há alterações tão significativas. Na verdade, é notório até mesmo uma ligeira queda no valor médio em
-- tempos de pico, como novembro de 2017, chegando a 136 reais.


	
