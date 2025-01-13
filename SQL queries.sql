use entertainment;

-- 1. Retrieve the names of all tracks that have more than 1 billion streams.
select track,stream from spotify_dataset where stream>=1000000000;

-- 2. List all albums along with their respective artists.
select distinct album,artist from spotify_dataset group by album,artist;

-- 3. Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) as Total_comments from spotify_dataset where licensed='true';

-- 4. Find all tracks that belong to the album type single.
select title from spotify_dataset where album_type='single';

-- 5. Count the total number of tracks by each artist.
select artist , count(*)from spotify_dataset group by artist;

-- 6. Calculate the average danceability of tracks in each album.
select album,avg(danceability) as average_danceability from spotify_dataset  group by album;

-- 7. Find the top 5 tracks with the highest energy values.
select title,energyliveness from spotify_dataset order by energyliveness DESC limit 5;

-- 8. List all tracks along with their views and likes where official_video = TRUE.
select title , views ,likes from spotify_dataset where official_video='TRUE';

-- 9. For each album, calculate the total views of all associated tracks.
select album,sum(views) as total_views from spotify_dataset group by album;

-- 10. Retrieve the track names that have been streamed on Spotify more than YouTube.
select track from (select track ,
coalesce(sum(case when most_playedon='spotify' then stream end),0)as streamed_on_spotify,
coalesce(sum(case when most_playedon='Youtube' then stream end),0) as streamed_on_youtube
from spotify_dataset 
group by track) as t1
where streamed_on_spotify>streamed_on_youtube;

-- 11. Find the top 3 most-viewed tracks for each artist using window functions.
select track,artist,views from (select track ,artist,views ,
Rank() over(partition by artist order by views DESC) as r1 from spotify_dataset) as o where r1>=3 
order by artist,r1 limit 3;

-- 12. Write a query to find tracks where the liveness score is above the average.
select track,artist,energyliveness from spotify_dataset where energyliveness>
(select avg(energyliveness) from spotify_dataset ) ;

-- 13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
with cte as (select album,max(energy) as highest,min(energy) as lowest from spotify_dataset group by album) 
select album ,highest-lowest as difference from cte order by  difference desc;

-- 14. Find tracks where the energy-to-liveness ratio is greater than 1.2.
SELECT Track, Energy, Liveness, (Energy / energyLiveness) AS Energy_Liveness_Ratio
FROM spotify_dataset
WHERE (Energy / energyLiveness) > 1.2;

-- 15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT 
    Track, 
    Views, 
    Likes, 
    SUM(Likes) OVER (ORDER BY Views DESC) AS Cumulative_Likes
FROM spotify_dataset
ORDER BY Views DESC;

