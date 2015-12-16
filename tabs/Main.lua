supportedOrientations(LANDSCAPE_ANY)
displayMode(FULLSCREEN)

function setup()
    lastProblem="" --previous problem
    tries,value,right,wrong,size=0,0,0,0,30
    offset=vec2(WIDTH/2,HEIGHT/2)
    b={"0️⃣","1️⃣","2️⃣","3️⃣","4️⃣","5️⃣","6️⃣","7️⃣","8️⃣","9️⃣","❌","🔙","☑️"}
    pos={vec2(-150,-300),vec2(-250,0),vec2(-150,0),vec2(-50,0),vec2(-250,-100),
        vec2(-150,-100),vec2(-50,-100),vec2(-250,-200),vec2(-150,-200),vec2(-50,-200),
        vec2(-250,-300),vec2(-50,-300),vec2(80,115)}
    create()
end

function create()    
    a,ans,str={},{},{}
    choice=math.random(4)
    c=math.random(4)
    for z=1,4 do
        if c==1 then    --  add
            a[z]=vec2(math.random(99),math.random(99))
            str[z]=string.format("%d + %d = ",a[z].x,a[z].y)
            ans[z]=math.tointeger(a[z].x+a[z].y)
        elseif c==2 then    --  subtract
            a1=math.random(99)
            a2=math.random(99)
            a[z]=vec2(math.max(a1,a2),math.min(a1,a2))  -- prevent negative answer
            str[z]=string.format("%d - %d = ",a[z].x,a[z].y)
            ans[z]=math.tointeger(a[z].x-a[z].y)
        elseif c==3 then    -- multiply
            a[z]=vec2(math.random(99),math.random(99))
            str[z]=string.format("%d x %d = ",a[z].x,a[z].y)
            ans[z]=math.tointeger(a[z].x*a[z].y)
        elseif c==4 then    -- divide
            a1=math.random(30)
            a2=math.random(50,99)//a1
            a[z]=vec2(a1*a2,a1) -- prevent fractional answer
            str[z]=string.format("%d / %d = ",a[z].x,a[z].y)
            ans[z]=a[z].x/a[z].y
        end        
    end
end

function touched(t)
    if t.state==ENDED then --wait for touch to end
        for i=0,9 do
            if vec2(t.x,t.y):dist(pos[i+1]+offset)<size then
                value=value*10+i
                break
            end
        end
        if vec2(t.x,t.y):dist(pos[11]+offset)<size then        -- clear
            value=0
        elseif vec2(t.x,t.y):dist(pos[12]+offset)<size then    -- backspace
            value=value//10
        elseif vec2(t.x,t.y):dist(pos[13]+offset)<size then    -- enter
            if value==ans[choice] then
                corr=true
                lastProb=str[choice]..math.tointeger(ans[choice])
                create()
                right=right+1
                tries=0
            else
                wrong=wrong+1
                tries=tries+1
                if tries>2 then  -- allow 3 tries
                    corr=false
                    lastProb=str[choice]..math.tointeger(ans[choice])
                    tries=0
                    create()
                end
            end
            value=0
        end        
    end
end

function draw()
    --background(40, 40, 50, 255)
    sprite("SpaceCute:Background", WIDTH/2, HEIGHT/2, 1024, 768)

    stroke(0, 0, 0, 255) -- will give an outline to the rectangles 
    strokeWidth(3)

    -- draws the keypad background 
    fill(255, 255, 255, 255)
    rect(offset.x-300, offset.y-345,300,400)
    fill(255)
    fontSize(80)

    for i=1,13 do -- these are the buttons being drawn
        text(b[i],offset.x+pos[i].x,offset.y+pos[i].y)
    end
    
    -- this displays the "Right" and "Wrong" at the top of the screen and their values
    fontSize(48)
    text("Right "..right,offset.x-100,HEIGHT-50) -- "Right 0" 
    text("Wrong "..wrong,offset.x+100,HEIGHT-50) -- "Wrong 0"
    
    -- this show the keyed value
    rect(offset.x-300, offset.y+90, 300, 50) -- Input bar
    fill(0, 0, 0, 255)
    text(value,offset.x-150,offset.y+115) --keyed value
    
    -- this displays the professor sprite and his speech bubble
    sprite("Planet Cute:Character Boy", offset.x+225,offset.y-100, 350, 600) -- sprite on the right side of screen
    sprite("Platformer Art:Cloud 3", offset.x+240, offset.y+80, 250, 150)   -- cloud sprite 
    
    -- this displays the problem to solve
    fill(0, 0, 0, 255) 
    text(str[choice],offset.x+255,offset.y+50) --problem placed in/on top of the cloud
    
    -- this displays the last problem, green was right, red was wrong
    if corr then
        fill(0,255,0)
    else 
        fill(255, 0, 0, 255)
    end
    text(lastProblem, WIDTH-300, 50) --displays the correct answer in the bottom right corner under the sprite 
end