
select p.codf, p.descr, (p.stoc+a.stoc) as stock, max(k.fecha) as ultima_venta
from BdNava01.dbo.prd0101 p
left join BdNava01.dbo.kdd0102 k on p.codi = k.codi
left join BdNava01.dbo.prd0102 a on p.codi = a.codi
WHERE k.tmov = 'S' 
	AND (k.nomglo = 'VTA. AL PERSONAL' OR k.nomglo = 'MERCADERIA' OR k.nomglo='VENTA DE PRODUCTOS') 
group by p.codf, p.descr, (p.stoc+a.stoc)
order by ultima_venta desc

--ON ALL ITEMS
select p.codf, p.descr, k.fecha
from BdNava01.dbo.prd0101 p
left join BdNava01.dbo.kdd0102 k on p.codi = k.codi

--BY CRITERIA
SELECT p.codf, p.descr, max_k.ultimaVenta, DATEDIFF(DAY, max_k.ultimaVenta, GETDATE()) AS dias_sin_vender
FROM BdNava01.dbo.prd0101 p
LEFT JOIN (
    SELECT codi, MAX(fecha) AS ultimaVenta
    FROM BdNava01.dbo.kdd0102
    WHERE tmov = 'S' 
        AND (nomglo = 'VTA. AL PERSONAL' OR nomglo = 'MERCADERIA' OR nomglo = 'VENTA DE PRODUCTOS')
    GROUP BY codi
) AS max_k ON p.codi = max_k.codi
WHERE p.codf = '16528'
ORDER BY max_k.ultimaVenta ASC;

--ALL
SELECT p.codf, p.descr, CAST(p.stoc+a.stoc AS DECIMAL(18,2)) AS stock, CONVERT(DATE,max_k.ultimaVenta) AS ultima_venta, DATEDIFF(DAY, max_k.ultimaVenta, GETDATE()) AS dias_sin_vender
FROM BdNava01.dbo.prd0101 p
LEFT JOIN BdNava01.dbo.prd0102 a ON p.codi = a.codi
LEFT JOIN (
    SELECT codi, MAX(fecha) AS ultimaVenta
    FROM BdNava01.dbo.kdd0102
    WHERE tmov = 'S' 
        AND (nomglo = 'VTA. AL PERSONAL' OR nomglo = 'MERCADERIA' OR nomglo = 'VENTA DE PRODUCTOS')
    GROUP BY codi
) AS max_k ON p.codi = max_k.codi
GROUP BY p.codf, p.descr, p.stoc+a.stoc, max_k.ultimaVenta
ORDER BY max_k.ultimaVenta ASC;

--ULTIMO INGRESO POR PRODDUCTO GENERAL
SELECT I.codf, I.descr, max(I.fecha) as fecha
FROM BdNava01.dbo.mst01gim G
INNER JOIN BdNava01.dbo.dtl01gim I ON G.ndocu = I.ndocu
where i.codf = '18445'
group by I.codf, I.descr
order by I.codf


---------------------------
SELECT codf, descr, ndocu, fecha
FROM (
    SELECT I.codf, I.descr, I.ndocu, I.fecha,
        ROW_NUMBER() OVER (PARTITION BY I.codf, I.descr, I.ndocu ORDER BY I.fecha DESC) as rn
    FROM BdNava01.dbo.mst01gim G
    INNER JOIN BdNava01.dbo.dtl01gim I ON G.ndocu = I.ndocu
) AS sub
WHERE rn = 1
ORDER BY codf;
-----------------------------------
select * from BdNava01.dbo.dtl01gim


 SELECT *
 FROM mst01gim
 WHERE crefe = '28' AND (codglo = '01' OR codglo = '16' OR codglo = '20')
 ORDER BY fecha, ndocu ASC





select 
   --ndocu, 
   RTRIM(codf) codf, 
   --RTRIM(descr) descr,
   max(fecha) as fecha
   --cant
  from BdNava01.dbo.dtl01gim
group by 
   --ndocu, 
   codf 
   --descr,
   --cant
order by codf, fecha asc

select 
   codf, 
   max(fecha) as fecha,
   cant
  from BdNava01.dbo.dtl01gim
group by  
   codf 
   cant
order by codf, fecha asc




SELECT *
 FROM mst01gim
 WHERE crefe = '28' AND (codglo = '01' OR codglo = '16' OR codglo = '20')
 ORDER BY fecha, ndocu ASC

--Tabla ultimo ingreso
SELECT 
   RTRIM(t1.codf) AS codf,
   RTRIM(t1.marc) AS marca,
   RTRIM(t1.descr) AS descr,
   CONVERT(varchar(10), t1.fecha, 103) as ult_ingreso,
   SUM(t1.cant) AS cant,
   t1.ndocu	
FROM BdNava01.dbo.dtl01gim AS t1
LEFT JOIN BdNava01.dbo.mst01gim F ON t1.ndocu = F.ndocu
WHERE t1.fecha = (
   SELECT MAX(t2.fecha)
   FROM BdNava01.dbo.dtl01gim AS t2
   WHERE t1.codf = t2.codf
)  AND t1.cant>0 AND (F.codglo = '01' OR F.codglo = '16' OR F.codglo = '20') --AND F.crefe = '28'
GROUP BY t1.codf, t1.marc, t1.descr, t1.fecha, t1.ndocu
ORDER BY t1.codf ASC


SELECT 
  *	
FROM BdNava01.dbo.dtl01gim AS t1
LEFT JOIN BdNava01.dbo.mst01gim F ON t1.ndocu = F.ndocu
WHERE f.ndocu = '001-00015968'


ORDER BY t1.marc ASC
