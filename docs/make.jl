using Documenter, Diana

makedocs(format = Documenter.HTML(),
         modules = [Diana],
         sitename = "Diana.jl"
         )
deploydocs(
	repo = "github.com/codeneomatrix/Diana.jl.git"
	#devbranch = "master",
    #devurl = "dev",
    #versions = ["stable" => "v^", "v#.#", "devurl" => devurl]
    )
