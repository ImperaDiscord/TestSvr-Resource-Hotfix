-- TriggerEvent('esx_policedog:openMenu') to open menu

Config = {
    Job = {'ambulance'},
    Command = 'policechien', -- set to false if you dont want to have a command
    Model = 1318032802,
    TpDistance = 50.0,
    Sit = {
        dict = 'creatures@rottweiler@amb@world_dog_sitting@base',
        anim = 'base'
    },
    Drugs = {'bagofdope', 'coke_pooch', 'meth_pooch', 'crack_pooch'}, -- add all drugs here for the dog to detect
    Items = {'water', 'bread', 'phone', 'gps'}, -- add all drugs here for the dog to detect
}

Strings = {
    ['not_police'] = 'You are ~r~not ~s~ a ambulance!',
    ['menu_title'] = 'Dog Ambulancier',
    ['take_out_remove'] = 'Husky',
    --['take_out_remove1'] = 'Chop',
    ['deleted_dog'] = 'Send the dog back',
    ['spawned_dog'] = 'Call the dog',
    ['sit_stand'] = 'Don\'t move stay here!',
    ['no_dog'] = "You don't have a dog",
    ['dog_dead'] = 'Your dog is dead',
    --['search_items'] = 'Le chien cherche autour de lui des objets suspect',
    --['no_items'] = 'Aucun objet trouvé.',
    --['items_found'] = 'Waf!Waf! un objet suspect trouvé!',
    --['search_drugs'] = 'Le chien cherche autour de lui',
    --['no_drugs'] = 'Aucune drogue trouver.', 
    --['drugs_found'] = 'Waf!Waf! de la drogue!',
    ['dog_too_far'] = 'The dog is far too far!',
    ['small'] = 'Treat the Dog!',
    ['heal_inprogress'] = 'You take care of the Dog',
    --['attack_closest'] = 'Attaquez joueur proche',
}