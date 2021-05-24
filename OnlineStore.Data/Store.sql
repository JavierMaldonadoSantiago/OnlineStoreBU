USE [Store]
GO
/****** Object:  Table [dbo].[Customers]    Script Date: 24/05/2021 09:52:57 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Customers](
	[CustomerId] [int] NOT NULL,
	[CustomerName] [varchar](80) NOT NULL,
	[CustomerEmail] [varchar](120) NOT NULL,
	[CustomerMobile] [varchar](40) NOT NULL,
 CONSTRAINT [PK_Costumers] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 24/05/2021 09:52:57 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderId] [int] NOT NULL,
	[CustomerId] [int] NOT NULL,
	[Status] [varchar](20) NOT NULL,
	[CreateAt] [datetime] NOT NULL,
	[UpdateAt] [datetime] NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OrdersDetail]    Script Date: 24/05/2021 09:52:57 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrdersDetail](
	[OrderDetailId] [int] NOT NULL,
	[OrderId] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Pieces] [int] NOT NULL,
	[Amount] [decimal](18, 6) NOT NULL,
 CONSTRAINT [PK_OrdersDetail] PRIMARY KEY CLUSTERED 
(
	[OrderDetailId] ASC,
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Products]    Script Date: 24/05/2021 09:52:57 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Products](
	[ProductId] [int] NOT NULL,
	[Description] [varchar](100) NOT NULL,
	[Price] [decimal](18, 6) NOT NULL,
 CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Costumers] FOREIGN KEY([CustomerId])
REFERENCES [dbo].[Customers] ([CustomerId])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Costumers]
GO
ALTER TABLE [dbo].[OrdersDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrdersDetail_Orders] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([OrderId])
GO
ALTER TABLE [dbo].[OrdersDetail] CHECK CONSTRAINT [FK_OrdersDetail_Orders]
GO
ALTER TABLE [dbo].[OrdersDetail]  WITH CHECK ADD  CONSTRAINT [FK_OrdersDetail_Products] FOREIGN KEY([ProductId])
REFERENCES [dbo].[Products] ([ProductId])
GO
ALTER TABLE [dbo].[OrdersDetail] CHECK CONSTRAINT [FK_OrdersDetail_Products]
GO
/****** Object:  StoredProcedure [dbo].[Usp_Cust_AddCustomer]    Script Date: 24/05/2021 09:52:57 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================
-- Author: Javier Aristeo Maldonado Santiago
-- Create date: 18 Mayo, 2021
-- Description:	Registra un nuevo cliente
-- exec [dbo].[Usp_Cust_AddCustomer] 'Cliente 1', 'cliente1@hotmail.com', '5513762545'
-- =========================================================
CREATE PROCEDURE [dbo].[Usp_Cust_AddCustomer]
(
	 @CustomerName			VARCHAR(80),
	 @CustomerEmail			VARCHAR(120),
	 @CustomerMobile		VARCHAR(40)
)
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
  
  
		DECLARE @NewCustomerId INT

		SELECT @NewCustomerId = ISNULL(MAX(CustomerId), 0) + 1
		  FROM Customers 
     
		INSERT INTO CUSTOMERS (CustomerId, CustomerName, CustomerEmail, CustomerMobile)
			VALUES (@NewCustomerId, @CustomerName, @CustomerEmail, @CustomerMobile)
 
		SELECT @NewCustomerId

	END TRY

	BEGIN CATCH
		DECLARE @msg VARCHAR(2048) = 'Ocurrió un error al insertar un cliente:  ' + ERROR_MESSAGE()  
		RAISERROR (@msg, 16, 1)
		RETURN -1
	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Cust_GetCustomerByName]    Script Date: 24/05/2021 09:52:57 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================
-- Author: Javier Aristeo Maldonado Santiago
-- Create date: 18 Mayo, 2021
-- Description:	Consulta el id del cliente
-- exec [dbo].[Usp_Cust_GetCustomerByName] 'cliente1@hotmail.com'
-- =========================================================
CREATE PROCEDURE [dbo].[Usp_Cust_GetCustomerByName]
(
	 @CustomerEmail			VARCHAR(120)
)
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
  
  
		SELECT top 1 CustomerId, CustomerName AS Name, CustomerEmail AS Email, CustomerMobile AS Mobile
		  FROM Customers
		 WHERE CustomerEmail = @CustomerEmail


	END TRY

	BEGIN CATCH
		DECLARE @msg VARCHAR(2048) = 'Ocurrió un error al consultar el cliente:  ' + ERROR_MESSAGE()  
		RAISERROR (@msg, 16, 1)
		RETURN -1
	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Cust_GetCustomerId]    Script Date: 24/05/2021 09:52:57 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================
-- Author: Javier Aristeo Maldonado Santiago
-- Create date: 18 Mayo, 2021
-- Description:	Consulta el id del cliente
-- exec [dbo].[Usp_Cust_GetCustomerId] 'cliente1@hotmail.com'
-- =========================================================
CREATE PROCEDURE [dbo].[Usp_Cust_GetCustomerId]
(
	 @CustomerEmail			VARCHAR(120)
)
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
  
  
		DECLARE @CustomerId INT

		SELECT @CustomerId = CustomerId
		  FROM Customers
		 WHERE CustomerEmail = @CustomerEmail
     
		SELECT isnull(@CustomerId, 0)

	END TRY

	BEGIN CATCH
		DECLARE @msg VARCHAR(2048) = 'Ocurrió un error al consultar el cliente:  ' + ERROR_MESSAGE()  
		RAISERROR (@msg, 16, 1)
		RETURN -1
	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Sales_AddOrder]    Script Date: 24/05/2021 09:52:57 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================
-- Author: Javier Aristeo Maldonado Santiago
-- Create date: 18 Mayo, 2021
-- Description:	Agrega una nueva orden del cliente especificado
-- exec [dbo].[Usp_Sales_AddOrder] 1, 'CREATED', 1, 2
-- =========================================================
CREATE PROCEDURE [dbo].[Usp_Sales_AddOrder]
(
	 @CustomerId			INT,
	 @Status			VARCHAR(20),
	 @ProductId			INT,
	 @Pices				INT
)
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		BEGIN TRAN
  
		DECLARE @NewOrderId INT

		SELECT @NewOrderId = ISNULL(MAX(OrderId), 0) + 1
		  FROM Orders 
     
		INSERT INTO Orders (OrderId, CustomerId, Status, CreateAt, UpdateAt)
			VALUES (@NewOrderId, @CustomerId, @Status, GETDATE(), NULL)
 
		

			DECLARE @NewOrderDetailId INT, @Price DECIMAL(18,6)

		SELECT @NewOrderDetailId = ISNULL(MAX(OrderDetailId), 0) + 1
		  FROM OrdersDetail 

		  SELECT @Price = Price
		    FROM Products
		   WHERE ProductId = @ProductId
     
		INSERT INTO OrdersDetail (OrderDetailId, OrderId, ProductId, Pieces, Amount)
			VALUES (@NewOrderDetailId, @NewOrderId, @ProductId, @Pices, @Pices * @Price)
		COMMIT TRAN
		SELECT @NewOrderId
	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		DECLARE @msg VARCHAR(2048) = 'Ocurrió un error al registrar la orden:  ' + ERROR_MESSAGE()  
		RAISERROR (@msg, 16, 1)
		RETURN -1
	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Sales_AddOrderDetail]    Script Date: 24/05/2021 09:52:57 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================
-- Author: Javier Aristeo Maldonado Santiago
-- Create date: 18 Mayo, 2021
-- Description:	Agrega el detalle de la orden especificada
-- exec [dbo].[Usp_Sales_AddOrderDetail] 1, 1, 2
-- =========================================================
CREATE PROCEDURE [dbo].[Usp_Sales_AddOrderDetail]
(
	 @OrderId			INT,
	 @ProductId			INT,
	 @Pices				INT
)
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
  
  
		DECLARE @NewOrderDetailId INT, @Price DECIMAL(18,6)

		SELECT @NewOrderDetailId = ISNULL(MAX(OrderDetailId), 0) + 1
		  FROM OrdersDetail 

		  SELECT @Price = Price
		    FROM Products
		   WHERE ProductId = @ProductId
     
		INSERT INTO OrdersDetail (OrderDetailId, OrderId, ProductId, Pieces, Amount)
			VALUES (@NewOrderDetailId, @OrderId, @ProductId, @Pices, @Pices * @Price)
 
		SELECT @NewOrderDetailId

	END TRY

	BEGIN CATCH
		DECLARE @msg VARCHAR(2048) = 'Ocurrió un error al registrar el detalle de la orden:  ' + @OrderId + ERROR_MESSAGE()  
		RAISERROR (@msg, 16, 1)
		RETURN -1
	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Sales_GetOrder]    Script Date: 24/05/2021 09:52:57 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================
-- Author: Javier Aristeo Maldonado Santiago
-- Create date: 18 Mayo, 2021
-- Description:	Consulta la orden del clinte activa para pago
-- exec [dbo].[Usp_Sales_GetOrder] 1
-- =========================================================
create PROCEDURE [dbo].[Usp_Sales_GetOrder]
(
	 @CustomerId			INT
)
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		
		SELECT top 1 o.OrderId, CustomerId, p.Description AS Product, od.Pieces, od.Amount, o.Status
		  FROM Orders o
			   INNER JOIN OrdersDetail od ON (o.OrderId = od.OrderId)
			   INNER JOIN Products p ON (od.ProductId = p.ProductId)
		 WHERE customerId = @CustomerId
		ORDER BY o.OrderId DESC

	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		DECLARE @msg VARCHAR(2048) = 'Ocurrió un error al consultar las ordenes del cliente:  ' + @CustomerId + ERROR_MESSAGE()  
		RAISERROR (@msg, 16, 1)
		RETURN -1
	END CATCH

END
GO
/****** Object:  StoredProcedure [dbo].[Usp_Sales_GetOrders]    Script Date: 24/05/2021 09:52:57 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =========================================================
-- Author: Javier Aristeo Maldonado Santiago
-- Create date: 18 Mayo, 2021
-- Description:	Consulta las ordenes del cliente espeficicado
-- exec [dbo].[Usp_Sales_GetOrders] 1
-- =========================================================
CREATE PROCEDURE [dbo].[Usp_Sales_GetOrders]
(
	 @CustomerId			INT
)
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRY
		
		SELECT o.OrderId, CustomerId, p.Description AS Product, od.Pieces, od.Amount, o.Status
		  FROM Orders o
			   INNER JOIN OrdersDetail od ON (o.OrderId = od.OrderId)
			   INNER JOIN Products p ON (od.ProductId = p.ProductId)
		 WHERE customerId = @CustomerId

	END TRY

	BEGIN CATCH
		ROLLBACK TRAN
		DECLARE @msg VARCHAR(2048) = 'Ocurrió un error al consultar las ordenes del cliente:  ' + @CustomerId + ERROR_MESSAGE()  
		RAISERROR (@msg, 16, 1)
		RETURN -1
	END CATCH

END
GO
