using CSV 
using DataFrames
using HTTP 



######################################################
# Function

######################################################


function read_ACS_data(file_name)
    url = "https://raw.githubusercontent.com/EMCMS/ACS.jl/main/datasets"
    url_data = joinpath(url,file_name)
    
    data = DataFrame(CSV.File(HTTP.get(url_data).body))
    return data
end

#file_name = "mtcars.csv"