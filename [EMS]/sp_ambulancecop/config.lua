-- TriggerEvent('esx_ambulancecop:openMenu') to open menu



Config = {

    Job = {'ambulance'},

    Command = '', -- set to false if you dont want to have a command

    Model = -1286380898,	

    TpDistance = 50.0,

    Sit = {

        dict = 'creatures@rottweiler@amb@world_cop_sitting@base',

        anim = 'base'

    },

    --Drugs = {'lsd_pooch', 'coke_pooch', 'meth_pooch', 'weed_pooch'}, -- add all drugs here for the cop to detect

}



Strings = {

    ['not_police'] = 'You are ~r~not ~s~ a ambulancier!',

    ['menu_title'] = '👨‍⚕️ Teammate menu ',

    ['take_out_remove'] = '👨‍⚕️ Man',	

    ['deleted_cop'] = '~r~Fire the teammate',

    ['spawned_cop'] = '~g~Call the teammate',

    ['sit_stand'] = '~b~Don\'t move stay here!',

    ['no_police'] = "~g~You don\'t have a teammate",

    ['cop_dead'] = '~r~Your teammate is dead',

    --['search_drugs'] = 'Le Coéquipier cherche autour de lui',

    --['no_drugs'] = 'Aucune corp trouver.', 

    --['drugs_found'] = 'il y\'a un corp!',

    ['cop_too_far'] = '~b~Teammate is way too far!',

    --['attack_closest'] = 'Attaquer joueur proche'

}