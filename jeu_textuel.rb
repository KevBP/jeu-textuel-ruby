class Personne
  attr_accessor :nom, :points_de_vie, :en_vie

  def initialize(nom)
    @nom = nom
    @points_de_vie = 100
    @en_vie = true
  end

  def info
    if en_vie
      "#{@nom} (#{@points_de_vie}/100)"
    else
      "#{@nom} (vaincu)"
    end
  end

  def attaque(personne)
    puts "#{@nom} attaque #{personne.nom}."
    if self.class == Joueur
      puts "#{@nom} possède #{degats_bonus} de bonus d'attaque."
    end
    personne.subit_attaque(degats)
  end

  def subit_attaque(degats_recus)
    @points_de_vie -= degats_recus
    @en_vie = @points_de_vie > 0
    puts "#{@nom} subit #{degats_recus} points de dégâts !"
  end
end

class Joueur < Personne
  attr_accessor :degats_bonus

  def initialize(nom)
    @degats_bonus = 0
    super(nom)
  end

  def degats
    1 + Random.rand(40) + @degats_bonus
  end

  def soin
    if @points_de_vie >= 100
      puts "#{@nom} ne peut se soigner n'étant pas blessé(e)."
    else
      s = 1 + Random.rand(40)
      if (@points_de_vie + s) > 100
        s = 100 - @points_de_vie
        @points_de_vie = 100
      else
        @points_de_vie += s
      end
      puts "#{@nom} a regargné #{s} points de vie (#{@points_de_vie}/100)."
    end
  end

  def ameliorer_degats
    b = 5 + Random.rand(30)
    @degats_bonus += b
    puts "#{@nom} gagne #{b} points bonus de dégât (pour un bonus total de #{@degats_bonus})."
  end
end

class Ennemi < Personne
  def degats
    1 + Random.rand(10)
  end
end

class Jeu
  def self.actions_possibles(monde)
    puts "ACTIONS POSSIBLES :"
    puts "0 - Se soigner"
    puts "1 - Améliorer son attaque"
    i = 2
    monde.ennemis.each do |ennemi|
      puts "#{i} - Attaquer #{ennemi.info}"
      i = i + 1
    end
    puts "99 - Quitter"
  end

  def self.est_fini(joueur, monde)
    if monde.ennemis_en_vie.size == 0 || !joueur.en_vie
      true
    else
      false
    end
  end
end

class Monde
  attr_accessor :ennemis

  def ennemis_en_vie
    vivants = []
    @ennemis.each do |e|
      if e.en_vie
        vivants << e
      end
    end
    vivants
  end
end

monde = Monde.new
monde.ennemis = [
  Ennemi.new("Balrog"),
  Ennemi.new("Goblin"),
  Ennemi.new("Squelette")
]

joueur = Joueur.new("Jean-Michel Paladin")

puts "\n\nAinsi débutent les aventures de #{joueur.nom}\n\n"

100.times do |tour|
  puts "\n------------------ Tour numéro #{tour} ------------------"

  Jeu.actions_possibles(monde)

  puts "\nQUELLE ACTION FAIRE ?"
  choix = gets.chomp.to_i

  if choix == 0
    joueur.soin
  elsif choix == 1
    joueur.ameliorer_degats
  elsif choix == 99
    break
  else
    ennemi_a_attaquer = monde.ennemis[choix - 2]
    joueur.attaque(ennemi_a_attaquer)
  end

  puts "\nLES ENNEMIS RIPOSTENT !"
  monde.ennemis_en_vie.each do |ennemi|
    ennemi.attaque(joueur)
  end

  puts "\nEtat du héro: #{joueur.info}\n"

  break if Jeu.est_fini(joueur, monde)
end

puts "\nGame Over!\n"

if joueur.en_vie
  puts "Vous avez gagné, #{joueur.info} !"
else
  puts "Vous avez perdu !"
end
