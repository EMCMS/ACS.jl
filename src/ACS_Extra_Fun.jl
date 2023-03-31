using CSV 
using DataFrames
using HTTP 



######################################################
# Function

######################################################


function read_ACS_data(file_name)
    url = "https://raw.githubusercontent.com/EMCMS/ACS.jl/main/datasets"
    
    
    data = DataFrame(CSV.File(HTTP.get(url * "/" *  file_name).body))
    return data
end

#file_name = "mtcars.csv"