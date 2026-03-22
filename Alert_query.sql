//showing the alerts after receiving data from python code
select v.owner_name, d.time_stamp,
    trim(
        concat(
                case when d.engine_temp > 90 then 'OVERHEATING ' else '' end,
                case when d.battery < 9 then 'LOW BATTERY ' else '' end,
                case when d.speed > 85 then 'HIGH SPEED ' else '' end
            )
        )as alerts,
        case 
            when d.engine_temp > 90 then 'OVERHEATING'
            when d.battery < 9 then 'LOW BATTERY'
            when d.speed > 85 then 'HIGH SPEED'
            else 'NORMAL'
        end as priority
from vehicle_data d
join vehicles v
on d.vehicle_id = v.id
order by d.time_stamp desc;