-- Exploratory Data Analysis
SELECT *
FROM layoffs_staging_2;

 -- Highest total_laid_off  and max percentage_laid_off
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging_2;

 -- Comapnies that laid off all their employees
SELECT *
FROM layoffs_staging_2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- grouping companies with total laid off in Desc order
SELECT  company, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY company
ORDER BY 2 DESC;

-- Date bw all the layoffs
SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging_2;

 -- Grouping industry to tell which had the highest layoff
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY industry
ORDER BY 2 DESC;

 -- Grouping countries with highest layoff
SELECT country, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY country
ORDER BY 2 DESC;

 -- Grouping Year with highest layoff
UPDATE layoffs_staging_2  
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y')  
WHERE `date` IS NOT NULL; -- handling null date values

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

 -- grouping by stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY stage
ORDER BY 2 DESC;

 -- Rolling total of layoffs,  grouping months of the years
WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1,7) AS MONTH, SUM(total_laid_off) AS total_off
FROM layoffs_staging_2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off, sum(total_off) OVER (ORDER BY `MONTH`) AS Rolling_Total
FROM Rolling_total;

-- Ranking companies yearly layoffs (Ranking every year)
  -- creating 1st CTE 
WITH Company_year(company, years, total_laid_off) AS 
(
SELECT company, YEAR(`date`),  SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY company, YEAR(`date`)
), 
  -- CTE 2
Company_year_rank AS
(
SELECT * , DENSE_RANK() OVER( PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_year
WHERE  years IS NOT NULL
)
SELECT *
FROM Company_year_rank; 

