-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')
-- raquette
local pad = {}

pad.x = 1
pad.y = 1
pad.hauteur = 20
pad.largeur = 80

-- balle
local balle = {}
balle.x = 0
balle.y = 0
balle.rayon = 10
balle.colle = false

local balls = {}

-- vitesse balle en px / s
balle.vx = 0
balle.vy = 0
-- pour incrementer la viteese de la balle
local deltaspeed = nil


-- briques
local brique = {}
local niveau = {}

 
-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end


function Demarre()
  balle.colle = true
  -- reinit niveau
  niveau = {}
  local l, c
  for l=1, 6 do
      niveau[l] = {}
    for c=1, 15 do
      niveau [l][c] = 1
    end
    
  end
  
end

  

function love.load()
  
  love.window.setMode(1024,768)
  
  largeur = love.graphics.getWidth()
  hauteur = love.graphics.getHeight()
  brique.hauteur = 25
  brique.largeur = largeur / 15
  
  print("largeur : "..largeur)
  print("hauteur : "..hauteur)
  pad.y = hauteur - (pad.hauteur / 2)
  
  Demarre()
  
end

function love.update(dt)
  pad.x = love.mouse.getX();
  if balle.colle then
    balle.x = pad.x
    balle.y = pad.y - (pad.hauteur / 2) - balle.rayon
  else
    balle.x = balle.x + balle.vx * dt
    balle.y = balle.y + balle.vy * dt
   
  end
  
 
  
  if balle.x > largeur  then
    balle.x = largeur
    balle.vx = -balle.vx
  elseif balle.x < 0  then
    balle.x = 0
    balle.vx = -balle.vx
  end
  
  if balle.y < 0 then
    balle.y = 0
    balle.vy = -balle.vy
  end
  
   --- collision balle brique
  local l, c
  c = math.floor(balle.x / brique.largeur) + 1 
  l = math.floor(balle.y / brique.hauteur) + 1
  -- collision avec une brique
  if (l >= 1) and (l <= #niveau) and (c >=1) and (c <= 15) then
      if niveau[l][c] == 1 then
        niveau[l][c] = 0
        balle.vy = -balle.vy
      end
  end  
  
  
  
  
  -- tester si contact avec le pad
  local posCollision = pad.y - pad.hauteur / 2 - balle.rayon
  
  if balle.y > posCollision then
    local dist = math.abs(pad.x - balle.x) 
    if dist < (pad.largeur / 2)  then
      balle.y = posCollision
      -- on augmente la vitesse
      incrementeVitesse(deltaspeed)
      balle.vy = -balle.vy
      
    end
  end

  -- test perdu 
  if balle.y > hauteur then
    balle.colle=true
    Demarre()
  end
  
  
end

function love.draw()
    -- dessin des briques
    local l, c
    --local bx, by = 0, 0
    for l = 1, 6 do
       --bx = 0 
       for c=1, 15 do
         if niveau[l][c] == 1 then
           -- on dessine une brique
           love.graphics.rectangle('fill', (c-1) * brique.largeur + 1, (l-1) * brique.hauteur + 1, brique.largeur - 2, brique.hauteur - 2)
           --love.graphics.rectangle('fill', bx + 5, by + 5, brique.largeur - 5, brique.hauteur - 5)
         end
         --bx = bx + brique.largeur
       end
      --by=by + brique.hauteur  
       
    end
    
    
    love.graphics.rectangle('fill', pad.x - pad.largeur / 2 , pad.y - pad.hauteur / 2, pad.largeur, pad.hauteur)
    
    love.graphics.circle('fill',balle.x, balle.y, balle.rayon)
end

-- appelé 60 fois par secondes
function love.mousepressed(x, y, n)
   if (balle.colle) then
    balle.colle=false
    balle.vx = 200
    balle.vy = -200
    deltaspeed = 10
   end
   
end


function love.keypressed(key)
  
  print(key)
  
end


function incrementeVitesse(delta)
  if balle.vx < 0 then
   balle.vx = balle.vx - delta
  else
    balle.vx = balle.vx + delta
  end
  
  balle.vy = math.abs(balle.vy) + delta
end
