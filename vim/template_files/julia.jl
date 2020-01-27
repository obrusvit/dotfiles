"

 author: Obrusnik Vit
"

function main()
    println(PROGRAM_FILE," start!")

    println(PROGRAM_FILE," Done!")
end

if abspath(PROGRAM_FILE) == @__FILE__
    @time main()
end
