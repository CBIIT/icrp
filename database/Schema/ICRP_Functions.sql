/****************************************************************************************************/
/****** Object:  UserDefinedFunction [dbo].[ToIntTable]    Script Date: 12/27/2016 11:59:17 AM ******/
/****************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ToIntTable](@input AS Varchar(4000) )
RETURNS
      @Result TABLE(Value INT)
AS
BEGIN
      DECLARE @Value INT
      DECLARE @ind Int

      IF(@input is not null)
      BEGIN
            SET @ind = CharIndex(',',@input)
            WHILE @ind > 0
            BEGIN
                  SET @Value = CAST(SUBSTRING(@input,1, @ind-1 ) AS INT)
                  SET @input = SUBSTRING(@input,@ind+1,LEN(@input)-@ind)
                  INSERT INTO @Result values (@Value)
                  SET @ind = CharIndex(',',@input)
            END
            SET @Value = CAST(@input AS INT)
            INSERT INTO @Result values (@Value)
      END
      RETURN
END
 
 GO

/****************************************************************************************************/
/****** Object:  UserDefinedFunction [dbo].[ToStrTable]    Script Date: 12/27/2016 11:59:24 AM ******/
/****************************************************************************************************/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[ToStrTable](@input AS Varchar(4000) )
RETURNS
      @Result TABLE(Value varchar(250))
AS
BEGIN
      DECLARE @str VARCHAR(20)
      DECLARE @ind Int

      IF(@input is not null)
      BEGIN
            SET @ind = CharIndex(',',@input)
            WHILE @ind > 0
            BEGIN
                  SET @str = SUBSTRING(@input,1, @ind-1 )
                  SET @input = SUBSTRING(@input,@ind+1,LEN(@input)-@ind)
                  INSERT INTO @Result values (@str)
                  SET @ind = CharIndex(',',@input)
            END
            SET @str = @input
            INSERT INTO @Result values (@str)
      END
      RETURN
END


GO




