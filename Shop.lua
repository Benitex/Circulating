----------------
-- Shop class --
----------------

Shop = {}

Shop.coins = 0
Shop.totalCoins = 0
Shop.coinsCooldown = 0

Shop.items = {}

function Shop.receiveCoins(dt)
    Shop.coinsCooldown = Shop.coinsCooldown + dt
        if Shop.coinsCooldown >= 1 then
            Shop.coins = Shop.coins + 1
            Shop.totalCoins = Shop.totalCoins + 1
            Shop.coinsCooldown = 0
        end
end

return Shop