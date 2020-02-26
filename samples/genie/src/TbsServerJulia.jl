module TbsServerJulia

using Logging, LoggingExtras

function main()
  Base.eval(Main, :(const UserApp = TbsServerJulia))

  include(joinpath("..", "genie.jl"))

  Base.eval(Main, :(const Genie = TbsServerJulia.Genie))
  Base.eval(Main, :(using Genie))
end; main()

end
