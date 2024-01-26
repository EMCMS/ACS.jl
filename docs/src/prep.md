# Julia Programming Language



## Installation
### Julia 
1.	Download the long term support (LTS) release for Julia from: [https://julialang.org/downloads/](https://julialang.org/downloads/)

2.	Execute the file and follow the installation steps. Make sure to write down the installation path or use the default path (This information will be required in a later step).

![julia_down](https://github.com/EMCMS/ACS.jl/blob/main/docs/assets/juliaLTS.PNG?raw=true)



### Visual Studio Code
1.	Download and install Visual Studio Code (VScode) from: [https://code.visualstudio.com/download](https://code.visualstudio.com/download)

2.	To open the extension marketplace, press (Ctrl+Shift+X) or press the marketplace button on the left side of the screen

3.	Search for julia. 

4.	Select the first package named Julia and install. 

5.	After installation restart VS Code for the next steps.

![julia_ex](https://github.com/EMCMS/ACS.jl/blob/main/docs/assets/JuliaExtension.PNG?raw=true)



To ensure that VS Code can find the installed Julia language:

1.	Go to: file -> preferences -> settings. 

2.	Search for the Julia.executablePath (Figure below).

3.	Fill in the path (i.e., installation path noted before) to the Julia executable (Julia.exe). 


- In case you do not have the path you can do the following:

- Default path for Windows: C:\\Users\\[INSERTUSERNAME]\\AppData\\Local\\Programs\\Julia1.5.3\\bin\\julia.exe

- For windows, double slashes (\\) need to be used instead of single (\) because the single slash is interpreted as escape.

 
- To locate appdata folder, you can press the windows key and type: %appdata%

- Copy path and add \\Local......:

- [Copied path ending with \\AppData]\\Local\\Programs\\Julia-x.x.x\\bin \\julia.exe


- Default path for Mac: 

- MacintoshHD/users/[INSERTUSERNAME]/Applications/Julia-x.x.x.app/Contents/Resources/julia/bin/Julia


![julia_path](https://github.com/EMCMS/ACS.jl/blob/main/docs/assets/executablePath.PNG?raw=true)



### Julia package installation
To install packages we first need to start up Julia. To open the Julia REPL for executing commands press **Crtl+Shift+P** and search for **Julia: Start REPL** and press enter, opening up the following window:

![REPL](https://github.com/EMCMS/ACS.jl/blob/main/docs/assets/REPL.PNG?raw=true)


In the REPL execute the following lines of code in order to install packages. After a single command is executed, “julia >” re-appears and the next line can be executed (it might take a bit for the packages to finish downloading). Also, the lines are capital sensitive. In case there is a space (" ") in the user name, see the next section for installing the ACS package.

```julia
using Pkg
# Julia official packages
Pkg.add("CSV")

# Julia unofficial packages from repository
Pkg.add(PackageSpec(url="https://github.com/EMCMS/ACS.jl"))
```
The second package that is being installed contains all relevant functions and information for the Advanced Chemometrics and Statistics course.

!!! tip 
    For basic julia programming please check our tutorials as a part of the documentation of package [*DataSci4Chem.jl*](https://emcms.github.io/DataSci4Chem.jl/dev/). 

### Installing the ACS package with " " in username
The ACS package makes use of other packages, which includes Conda. However, the Conda package cannot install itself and will error if there is a space (" ") in the username (i.e., the path where Conda wants to install itself). Therefore, the following steps need to be followed to get Conda working. Make sure to carefully read the comments that follow after a #.

```julia
using Pkg
# Download Conda
Pkg.add("Conda")
# Start up
using Conda
# Change the installation path of Conda
ENV["CONDA_JL_HOME"] = "C:\\Conda-Julia"      #default/example path


# Now, before we can continue, make sure that this folder exist. Especially if a different path is chosen then the default.
# To create the folder in the default path run:
mkdir("C:\\Conda-Julia")


# Download PyCall package that uses Conda -> Ignore the error!
Pkg.add("PyCall")
Pkg.build("PyCall")


# Install the ACS package
Pkg.add(PackageSpec(url="https://github.com/EMCMS/ACS.jl"))

#!!! re-start Julia !!!

# Now the ACS package can be used through:
using ACS

```