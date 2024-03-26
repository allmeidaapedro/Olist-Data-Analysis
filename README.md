# Olist analysis
- In this project, I will analyze a brazilian e-commerece (Olist) sales data to answer 45 business questions utilizing SQL. After that, I will construct a dashboard in PowerBI to highlight the most important KPI'S and indicators about the business.

#### Data schema

<img src="data_schema.png">

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

#### Business questions
- How many unique customers are there in the database?
- How many orders were made?
- What was the total revenue?
- What are the top 5 cities with the most orders?
- How many orders were delivered in each state?
- What is the average payment value per order?
- Which product categories have the highest and lowest sales volume?
- How many sellers are there in each state?
- How many customers are there in each state?
- What is the average review score given by customers?
- What is the average freight value per order?
- How many orders were delivered late?
- What are the most common payment types?
- What is the average number of installments per payment?
- How many orders have multiple items?

- How does the review score vary by product category?
- What is the trend of the number of orders over the years?
- What is the trend of the number of orders over the week?
- What is the trend of the number of orders over the day?
- What is the month with the highest number of orders?
- What is the month with the highest revenue?
- What is the average delivery time for orders in each state?
- How many orders were canceled?
- What is the average payment value per product category?
- Which seller has the highest average order value?
- What is the average number of days between order approval and delivery?
- What is the average order value for orders with review scores of 1, 2, 3, 4, and 5?
- What is the average number of products per order?
- How many orders were delivered before the estimated delivery date?
- How many orders were delivered by the estimated delivery date?
- What is the average payment value for orders with different payment types?

- What are the top 5 most profitable product categories, their average review scores and the state that buys them most.
- What insights can be drawn from the relationship between the seller's location and the customer's location regarding late deliveries?
- Is there a correlation between the number of payment installments and the review score?
- How do delivery times vary between different product categories?
- Are there any observable trends in review scores?
- Is there a relationship between the seller's review score and the product's category?
- How does the average order value change during peak shopping seasons?
- Is there a relationship between the number of products in an order and the likelihood of a customer leaving a review?
- Is there a correlation between the distance of the seller from the customer and the likelihood of a late delivery?

In portuguese:

- Quantos clientes únicos existem no banco de dados?
- Quantos pedidos foram feitos?
- Qual foi a receita total?
- Quais são as 5 cidades com mais pedidos?
- Quantos pedidos foram entregues em cada estado?
- Qual é o valor médio de pagamento por pedido?
- Quais categorias de produtos têm o maior e o menor volume de vendas?
- Quantos vendedores existem em cada estado?
- Quantos clientes existem em cada estado?
- Qual é a pontuação média de avaliação dada pelos clientes?
- Qual é o valor médio do frete por pedido?
- Quantos pedidos foram entregues com atraso?
- Quais são os tipos de pagamento mais comuns?
- Qual é o número médio de parcelas por pagamento?
- Quantos pedidos têm múltiplos itens?

- Como a pontuação de avaliação varia por categoria de produto?
- Qual é a tendência do número de pedidos ao longo dos anos?
- Qual é a tendência do número de pedidos ao longo da semana?
- Qual é a tendência do número de pedidos ao longo do dia?
- Qual é o mês com o maior número de pedidos?
- Qual é o mês com a maior receita?
- Qual é o tempo médio de entrega para pedidos em cada estado?
- Quantos pedidos foram cancelados?
- Qual é o valor médio de pagamento por categoria de produto?
- Qual vendedor tem o maior valor médio de pedido?
- Qual é o número médio de dias entre a aprovação do pedido e a entrega?
- Qual é o valor médio do pedido para pedidos com pontuações de avaliação de 1, 2, 3, 4 e 5?
- Qual é o número médio de produtos por pedido?
- Quantos pedidos foram entregues antes da data de entrega estimada?
- Quantos pedidos foram entregues até a data de entrega estimada?
- Qual é o valor médio de pagamento para pedidos com diferentes tipos de pagamento?

- Quais são as 5 categorias de produtos mais lucrativas, suas pontuações médias de avaliação e o estado que as compra mais.
- Que insights podem ser tirados da relação entre a localização do vendedor e a localização do cliente em relação às entregas atrasadas?
- Existe correlação entre o número de parcelas de pagamento e a pontuação de avaliação?
- Como os tempos de entrega variam entre diferentes categorias de produtos?
- Existem tendências observáveis nas pontuações de avaliação?
- Existe relação entre a pontuação de avaliação do vendedor e a categoria do produto?
- Como o valor médio do pedido muda durante as temporadas de compras de pico?
- Existe relação entre o número de produtos em um pedido e a probabilidade de um cliente deixar uma avaliação?
- Existe correlação entre a distância do vendedor para o cliente e a probabilidade de uma entrega atrasada?
