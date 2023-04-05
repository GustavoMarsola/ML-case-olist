-- Databricks notebook source
WITH tb_join AS (

SELECT t2.*, t3.idVendedor

FROM silver.olist.pedido AS t1

LEFT JOIN silver.olist.pagamento_pedido as t2
ON t1.idPedido = t2.idPedido

LEFT JOIN silver.olist.item_pedido as t3
ON t1.idPedido = t3.idPedido

WHERE dtPedido < '2018-01-01'
AND dtPedido >= add_months('2018-01-01',-6)
AND t3.idVendedor IS NOT NULL
),

tb_group AS (

SELECT idVendedor,
        descTipoPagamento,
        count(DISTINCT idPedido) AS qtdePedidoMeioPagamento,
        sum(vlPagamento) AS vlPedidoMeioPagamento

FROM tb_join

GROUP BY idVendedor, descTipoPagamento
ORDER BY idVendedor, descTipoPagamento
)

SELECT idVendedor,

SUM(CASE WHEN descTipoPagamento = 'boleto' THEN qtdePedidoMeioPagamento ELSE 0 END) AS qtde_boleto_pedido,
SUM(CASE WHEN descTipoPagamento = 'credir_card' THEN qtdePedidoMeioPagamento ELSE 0 END) AS qtde_credir_card_pedido,
SUM(CASE WHEN descTipoPagamento = 'voucher' THEN qtdePedidoMeioPagamento ELSE 0 END) AS qtde_voucher_pedido,
SUM(CASE WHEN descTipoPagamento = 'debit_card' THEN qtdePedidoMeioPagamento ELSE 0 END) AS qtde_debit_card_pedido,

SUM(CASE WHEN descTipoPagamento = 'boleto' THEN qtdePedidoMeioPagamento ELSE 0 END) / sum(qtdePedidoMeioPagamento) AS prop_boleto_pedido,
SUM(CASE WHEN descTipoPagamento = 'credir_card' THEN qtdePedidoMeioPagamento ELSE 0 END) / sum(qtdePedidoMeioPagamento) AS prop_credir_card_pedido,
SUM(CASE WHEN descTipoPagamento = 'voucher' THEN qtdePedidoMeioPagamento ELSE 0 END) / sum(qtdePedidoMeioPagamento) AS prop_voucher_pedido,
SUM(CASE WHEN descTipoPagamento = 'debit_card' THEN qtdePedidoMeioPagamento ELSE 0 END) / sum(qtdePedidoMeioPagamento) AS prop_debit_card_pedido,

SUM(CASE WHEN descTipoPagamento = 'boleto' THEN vlPedidoMeioPagamento ELSE 0 END) AS valor_boleto_pedido,
SUM(CASE WHEN descTipoPagamento = 'credir_card' THEN vlPedidoMeioPagamento ELSE 0 END) AS valor_credir_card_pedido,
SUM(CASE WHEN descTipoPagamento = 'voucher' THEN vlPedidoMeioPagamento ELSE 0 END) AS valor_voucher_pedido,
SUM(CASE WHEN descTipoPagamento = 'debit_card' THEN vlPedidoMeioPagamento ELSE 0 END) AS valor_debit_card_pedido,

SUM(CASE WHEN descTipoPagamento = 'boleto' THEN vlPedidoMeioPagamento ELSE 0 END) / sum(vlPedidoMeioPagamento) AS pct_boleto_pedido,
SUM(CASE WHEN descTipoPagamento = 'credir_card' THEN vlPedidoMeioPagamento ELSE 0 END) / sum(vlPedidoMeioPagamento) AS pct_credir_card_pedido,
SUM(CASE WHEN descTipoPagamento = 'voucher' THEN vlPedidoMeioPagamento ELSE 0 END) / sum(vlPedidoMeioPagamento) AS pct_voucher_pedido,
SUM(CASE WHEN descTipoPagamento = 'debit_card' THEN vlPedidoMeioPagamento ELSE 0 END) / sum(vlPedidoMeioPagamento) AS pct_debit_card_pedido

FROM tb_group

GROUP BY 1