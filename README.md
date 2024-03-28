# Olist analysis
- In this project, I will analyze a brazilian e-commerece (Olist) sales data to answer 39 business questions utilizing SQL. After that, I will construct a dashboard in PowerBI to highlight the most important KPI'S and indicators about the business.
- What will you encounter here?
    - Aggregate functions such as COUNT, SUM, AVG, MIN, MAX, ROUND, EXTRACT, TO_CHAR, etc.
    - Clauses such as SELECT, WHERE, HAVING, GROUP BY, ORDER BY, LEFT JOIN, INNER JOIN, CASE WHEN, LIMIT.
    - Window functions such as RANK, with ROW, OVER, PARTITION BY.
    - CTE'S and Subqueries.

#### Data schema

<img src="data_schema.png">

#### Business questions
1. How many unique customers are there in the database?
2. How many orders were made?
3. What was the total revenue?
4. What are the top 5 cities with the most orders?
5. How many orders were delivered in each state?
6. What is the average payment value per order?
7. Which product categories have the highest and lowest sales volume?
8. How many sellers are there in each state?
9. How many customers are there in each state?
10. What is the average review score given by customers?
11. What is the average freight value per order?
12. How many orders were delivered late?
13. What are the most common payment types?
14. What is the average number of installments per payment?
15. How many orders have multiple items?
16. How does the review score vary by product category?
17. What is the trend of the number of orders over the years?
18. What is the trend of the number of orders over the week?
19. What is the trend of the number of orders over the day?
20. What is the month with the highest number of orders?
21. What is the month with the highest revenue?
22. What is the average delivery time for orders in each state?
23. How many orders were canceled?
24. What is the average payment value per product category?
25. Which seller has the highest average order value?
26. What is the average number of days between order approval and delivery?
27. What is the average order value for orders with review scores of 1, 2, 3, 4, and 5?
28. What is the average number of products per order?
29. How many orders were delivered before the estimated delivery date?
30. How many orders were delivered by the estimated delivery date?
31. What is the average payment value for orders with different payment types?
32. What are the top 5 most profitable product categories, their average review scores and the state that buys them most.
33. What insights can be drawn from the relationship between the seller's location and the customer's location regarding late deliveries?
34. Is there a correlation between the number of payment installments and the review score?
35. How do delivery times vary between different product categories?
36. Are there any observable trends in review scores?
37. Is there a relationship between the seller's review score and the product's category?
38. How does the average order value change during peak shopping seasons?
39. Is there a correlation between the distance of the seller from the customer and the likelihood of a late delivery?

In portuguese:
1. Quantos clientes únicos existem no banco de dados?
2. Quantos pedidos foram feitos?
3. Qual foi a receita total?
4. Quais são as 5 cidades com mais pedidos?
5. Quantos pedidos foram entregues em cada estado?
6. Qual é o valor médio de pagamento por pedido?
7. Quais categorias de produtos têm o maior e o menor volume de vendas?
8. Quantos vendedores existem em cada estado?
9. Quantos clientes existem em cada estado?
10. Qual é a pontuação média de avaliação dada pelos clientes?
11. Qual é o valor médio do frete por pedido?
12. Quantos pedidos foram entregues com atraso?
13. Quais são os tipos de pagamento mais comuns?
14. Qual é o número médio de parcelas por pagamento?
15. Quantos pedidos têm múltiplos itens?
16. Como a pontuação de avaliação varia por categoria de produto?
17. Qual é a tendência do número de pedidos ao longo dos anos?
18. Qual é a tendência do número de pedidos ao longo da semana?
19. Qual é a tendência do número de pedidos ao longo do dia?
20. Qual é o mês com o maior número de pedidos?
21. Qual é o mês com a maior receita?
22. Qual é o tempo médio de entrega para pedidos em cada estado?
23. Quantos pedidos foram cancelados?
24. Qual é o valor médio de pagamento por categoria de produto?
25. Qual vendedor tem o maior valor médio de pedido?
26. Qual é o número médio de dias entre a aprovação do pedido e a entrega?
27. Qual é o valor médio do pedido para pedidos com pontuações de avaliação de 1, 2, 3, 4 e 5?
28. Qual é o número médio de produtos por pedido?
29. Quantos pedidos foram entregues antes da data de entrega estimada?
30. Quantos pedidos foram entregues até a data de entrega estimada?
31. Qual é o valor médio de pagamento para pedidos com diferentes tipos de pagamento?
32. Quais são as 5 categorias de produtos mais lucrativas, suas pontuações médias de avaliação e o estado que as compra mais.
33. Que insights podem ser tirados da relação entre a localização do vendedor e a localização do cliente em relação às entregas atrasadas?
34. Existe correlação entre o número de parcelas de pagamento e a pontuação de avaliação?
35. Como os tempos de entrega variam entre diferentes categorias de produtos?
36. Existe correlação entre o tempo de entrega e a pontuação de avaliação?
37. Existem tendências observáveis nas pontuações de avaliação?
38. Como o valor médio do pedido muda durante as temporadas de compras de pico?
39. Existe correlação entre a distância do vendedor para o cliente e a probabilidade de uma entrega atrasada?

#### Tables descriptions

Customers Dataset
- This dataset has information about the customer and its location. Use it to identify unique customers in the orders dataset and to find the orders delivery location.
- customer_id identifies an id for the customer when he makes an order. The same customer can do different orders and thus have different customer_id values.
- customer_unique_id identifies an unique id for each customer. With this variable, it is possible to track a customer and his orders, which have a distinct id in customer_id variable.
- `customer_id`: Key to the orders dataset. Each order has a unique customer_id.
- `customer_unique_id`: Unique identifier of a customer.
- `customer_zip_code_prefix`: First five digits of customer zip code.
- `customer_city`: Customer city name.
- `customer_state`: Customer state.

Geolocation Dataset
- This dataset has information Brazilian zip codes and its lat/lng coordinates. Use it to plot maps and find distances between sellers and customers.
- `geolocation_zip_code_prefix`: First 5 digits of zip code
- `geolocation_lat`: Latitude.
- `geolocation_lng`: Longitude.
- `geolocation_city`: City name.
- `geolocation_state`: State.

Order Items Dataset
- This dataset includes data about the items purchased within each order.
- Example:
- The order_id = 00143d0f86d6fbd9f9b38ab440ac16f5 has 3 items (same product). Each item has the freight calculated accordingly to its measures and weight. To get the total freight value for each order you just have to sum.
- The total order_item value is: 21.33 * 3 = 63.99
- The total freight value is: 15.10 * 3 = 45.30
- The total order value (product + freight) is: 45.30 + 63.99 = 109.29
- `order_id`: Order unique identifier.
- `order_item_id`: Sequential number identifying number of items included in the same order.
- `product_id`: Product unique identifier.
- `seller_id`: Seller unique identifier.
- `shipping_limit_date`: Shows the seller shipping limit date for handling the order over to the logistic partner.
- `price`: Item price.
- `freight_value`: Item freight value (if an order has more than one item the freight value is split between items).

Payments Dataset
- This dataset includes data about the orders payment options.
- `order_id`: Unique identifier of an order.
- `payment_sequential`: A customer may pay an order with more than one payment method. If they do so, a sequence will be created to accommodate all payments.
- `payment_type`: Method of payment chosen by the customer.
- `payment_installments`: Number of installments chosen by the customer.
- `payment_value`: Transaction value.

Order Reviews Dataset
- This dataset includes data about the reviews made by the customers.
- After a customer purchases the product from Olist Store a seller gets notified to fulfill that order. Once the customer receives the product, or the estimated delivery date is due, the customer gets a satisfaction survey by email where he can give a note for the purchase experience and write down some comments.
- `review_id`: Unique review identifier.
- `order_id`: Unique order identifier.
- `review_score`: Note ranging from 1 to 5 given by the customer on a satisfaction survey.
- `review_comment_title`: Comment title from the review left by the customer, in Portuguese.
- `review_comment_message`: Comment message from the review left by the customer, in Portuguese.
- `review_creation_date`: Shows the date in which the satisfaction survey was sent to the customer.
- `review_answer_timestamp`: Shows satisfaction survey answer timestamp.

Order Dataset
- This is the core dataset. From each order you might find all other information.
- `order_id`: Unique identifier of the order.
- `customer_id`: Key to the customer dataset. Each order has a unique customer_id.
- `order_status`: Reference to the order status (delivered, shipped, etc).
- `order_purchase_timestamp`: Shows the purchase timestamp.
- `order_approved_at`: Shows the payment approval timestamp.
- `order_delivered_carrier_date`: Shows the order posting timestamp. When it was handled to the logistic partner.
- `order_delivered_customer_date`: Shows the actual order delivery date to the customer.
- `order_estimated_delivery_date`: Shows the estimated delivery date that was informed to customer at the purchase moment.

Products Dataset
- This dataset includes data about the products sold by Olist.
- `product_id`: Unique product identifier.
- `product_category_name`: Root category of product, in Portuguese.
- `product_name_length`: Number of characters extracted from the product name.
- `product_description_length`: Number of characters extracted from the product description.
- `product_photos_qty`: Number of product published photos.
- `product_weight_g`: Product weight measured in grams.
- `product_length_cm`: Product length measured in centimeters.
- `product_height_cm`: Product height measured in centimeters.
- `product_width_cm`: Product width measured in centimeters.

Sellers Dataset
- This dataset includes data about the sellers that fulfilled orders made at Olist. Use it to find the seller location and to identify which seller fulfilled each product.
- `seller_id`: Seller unique identifier.
- `seller_zip_code_prefix`: First 5 digits of seller zip code.
- `seller_city`: Seller city name.
- `seller_state`: Seller state.

#### Dataset link
- The dataset was collected from kaggle.
- Link: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce?select=olist_order_items_dataset.csv

#### Contact me
- Linkedin: https://www.linkedin.com/in/pedro-almeida-ds/
- Github: https://github.com/allmeidaapedro
- Gmail: pedrooalmeida.net@gmail.com
