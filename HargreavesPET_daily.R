# All credits go to authors of SPEI R package
# https://cran.r-project.org/web/packages/SPEI/index.html

HargreavesPET_daily <- function(date, tavg, tdif, lat){
  
  doy <- yday(date)
  phi = pi/180 * lat
  delta = 0.409*sin(2*pi/366*doy-1.39)
  dr = 1 + 0.033*cos(2*pi/365*doy)
  
  ws = try(acos(-tan(phi)*tan(delta)))
  
  # correction in case of NaN values
  ws <- ifelse(is.nan(ws), 0.1, ws)

  Ra = (24*60/pi)*0.0820*dr*((ws*sin(phi)*sin(delta))+(cos(phi)*cos(delta)*sin(ws)))
  
  PET = 0.0023*(tavg + 17.8)*sqrt(tdif) * Ra
  
  # correction in case of negative PET
  PET <- ifelse(PET < 0, 0, PET)

  return(PET)
}
