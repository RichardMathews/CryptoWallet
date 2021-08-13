namespace :dev do
  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Deletando") { %x(rails db:drop db) }

      show_spinner("Criando") { %x(rails db:create) }

      show_spinner("Migrando") { %x(rails db:migrate) }

      %x(rails dev:add_mining_types)
      %x(rails dev:add_coins)
    end
  end

  desc "Cadastra as moedas"
  task add_coins: :environment do
    show_spinner("Cadastando moedas...") do
      coins = [
        {
          description: "Bitcoin",
          acronym: "BTC",
          url_image: "http://pngimg.com/uploads/bitcoin/small/bitcoin_PNG47.png",
          mining_type: MiningType.all.sample
        },
        {
          description: "Ethereum",
          acronym: "ETH",
          url_image: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b7/ETHEREUM-YOUTUBE-PROFILE-PIC.png/600px-ETHEREUM-YOUTUBE-PROFILE-PIC.png",
          mining_type: MiningType.all.sample
        },
        {
          description: "Dash",
          acronym: "DASH",
          url_image: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxjTgpO79bA87wYfizORtCpTDw12CU6_KKk5xBnzUbaggNmkYoxHy13iYovDYJB4qDszM&usqp=CAU",
          mining_type: MiningType.all.sample
        }
      ]

      coins.each do |coin|
        Coin.find_or_create_by!(coin)
      end
    end
  end

  desc "Cadastra os tipos de mineração"
  task add_mining_types: :environment do
    show_spinner("Cadastando tipos de mineração...") do
      mining_types = [
        {description: "Proof of Work", acronym: "PoW"},
        {description: "Proof of Stake", acronym: "PoS"},
        {description: "Proof of Capacity", acronym: "PoC"},
      ]

      mining_types.each do |mining_type|
        MiningType.find_or_create_by!(mining_type)
      end
    end
  end

  private

  def show_spinner(msg_start, msg_end = "Done!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}...", format: :spin_2)
    spinner.auto_spin # Automatic animation with default interval
    yield
    spinner.success("#{msg_end}") # Stop animation
  end

end
