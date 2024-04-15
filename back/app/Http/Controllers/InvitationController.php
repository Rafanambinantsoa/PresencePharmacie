<?php

namespace App\Http\Controllers;

use App\Http\Resources\kimRes;
use App\Http\Resources\ParticipantRes;
use App\Http\Resources\PresentCollection;
use App\Models\evenement;
use App\Models\Presence;
use App\Models\User;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;

class InvitationController extends Controller
{
    //A controller who send An email to all User that an event is created
    public function EnvoieInvitation($id)
    {
        $event = evenement::find($id);
        if (!$event) {
            return response()->json([
                'message' => 'Evenement non trouvé'
            ], 404);
        }
        //envoie email a tous les utilisateurs sauf a l'admin qui a une role de admin
        $users = User::where('role', '!=', 'admin')->get();

        foreach ($users as $user) {
            try {
                Mail::send('mails.invitation', ['evenement' => $event, 'username' => $user->firstname], function ($message) use ($user) {
                    $message->to($user->email);
                    $message->subject('Nouvel événement');
                });
            } catch (Exception $e) {
                return response()->json([
                    'message' => 'Erreur lors de l\'envoie de l\'invitation',
                    'error' => $e->getMessage()
                ], 500);
            }
        }

        return response()->json([
            'message' => 'Invitation envoyée avec succès'
        ], 200);
    }

    //une methode pour le scan d'un user pour afficher son information grace a son Badgetoken
    public function showUserInformation($token)
    {
        $user = User::where('badgeToken', $token)->first();
        return response([
            "user" => $user
        ], 200);
    }

    //une methode pour la  premiere presence 
    public function firstPresence($event_id, $user_id)
    {
        Presence::create([
            'user_id' => $user_id,
            'evenement_id' => $event_id,
            'firstPresence' => true,
            'secondPresence' => false
        ]);

        return response()->json([
            'message' => 'Première présence enregistrée'
        ], 200);
    }

    //une methode pour la deuxieme presence
    public function secondPresence($event_id, $user_id)
    {
        $presence = Presence::where('user_id', $user_id)->where('evenement_id', $event_id)->first();
        if (!$presence) {
            return response()->json([
                'message' => 'Première présence non enregistrée'
            ], 404);
        }

        $presence->update([
            'secondPresence' => true
        ]);

        return response()->json([
            'message' => 'Deuxième présence enregistrée'
        ], 200);
    }

    //recuperer la liste de tous les invites  present 100%
    public function getListPresence($event_id)
    {
        // Récupérer les présences avec les informations utilisateur associées
        $presences = Presence::with('usera')
            ->where('evenement_id', $event_id)
            ->where('firstPresence', true)
            ->where('secondPresence', true)
            ->paginate(5);

        // Formater la réponse JSON
        $formattedResponse = [
            'data' => $presences->map(function ($presence) {
                // Extraire uniquement les informations nécessaires de l'utilisateur
                $user = $presence->usera;
                return [
                    'firstname' => $user->firstname,
                    'lastname' => $user->lastname,
                    'email' => $user->email,
                    'phone' => $user->phone,
                ];
            }),
            // Ajouter les informations de pagination
            'pagination' => [
                'current_page' => $presences->currentPage(),
                'from' => $presences->firstItem(),
                'to' => $presences->lastItem(),
                'per_page' => $presences->perPage(),
                'total' => $presences->total(),
                'prev_page_url' => $presences->previousPageUrl(),
                'next_page_url' => $presences->nextPageUrl(),
            ],
        ];

        return response()->json($formattedResponse);
    }


    //recuperer la liste de tous les invites qui sont venus au debut du soirer mais qui n'ont pas attendus jusqu'au contre scan (appele)
    public function getListPresenceFirst($event_id)
    {
        $presences = Presence::where('evenement_id', $event_id)->where('firstPresence', true)->where('secondPresence', false)->get();
        return response()->json([
            'presences' => $presences
        ], 200);
    }

    //recuper la liste de tous les invite qui ne sont pas venus faire le scan  
    public function getListAbsence($event_id)
    {
        //recuperer  tous les user de mon app except role admin  
        $usrs = User::where('role', '!=', 'admin')->get();
        //recuperer tous les user qui ont fait le premierscan
        $presences = Presence::where('evenement_id', $event_id)->where('firstPresence', true)->get();

        //comparer les deux tableaux pour recuperer les absents
        $absents = $usrs->diff($presences);

        return response()->json([
            'absents' => $absents
        ], 200);
    }
}
