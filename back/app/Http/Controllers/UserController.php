<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Validator;

class UserController extends Controller
{
    //allUser
    public function tousLesUser()
    {
        $data = User::all();
        return response($data);
    }
    //traitement de la reinitialisation du mot de passe
    public function resetPassword(Request $request)
    {
        $request->validate([
            'token' => 'required',
            'password' => 'required'
        ]);

        //check if user exists
        $user = User::where('password_reset_token', $request->token)->first();
        if (!$user) {
            return response()->json([
                'message' => 'User does not exist',
                'code' => 'error'
            ], 401);
        }

        //update user
        $user->update([
            'password' => bcrypt($request->password),
            'password_reset_token' => null,
        ]);

        return response()->json(
            [
                'message' => 'Mot de passe réinitialisé avec succès',
                'code' => 'success'
            ],
            200
        );
    }

    public function check($token)
    {
        $user = User::where('password_reset_token', $token)->first();
        if (!$user) {
            return redirect('http://localhost:3000/forgot?code=' . urlencode($token));
        }
        return redirect('http://localhost:3000/reset?code=' . urlencode($token));
    }

    public function forgotPassword(Request $request)
    {
        $user = User::where('email', $request->email)->first();
        if (!$user) {
            return response()->json([
                'message' => 'User does not exist'
            ], 401);
        }
        //generate  random string token
        $randomString = bin2hex(random_bytes(16));

        //update user
        $user->update([
            'password_reset_token' => $randomString,
        ]);

        Mail::send("mails.forgot", [
            'token' => $randomString,
            'user' => $user,
        ], function ($message) use ($user) {
            $message->to($user->email);
            $message->subject('Réinitialisation de votre mot de passe');
        });

        return response()->json([
            'message' => 'Email sent',
            'code' => 'success'
        ]);
    }

    public function update(User $user, Request $request)
    {
        $validator = Validator::make($request->all(), [
            'firstname' => 'required',
            'lastname' => 'required',
            'email' => 'required|email',
            'phone' => 'required|numeric',
            'password' => 'required',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'code' => 400,
                'message' => 'Veuillez remplir tous les champs'
            ]);
        }
        $test = Hash::check($request->password, $user->password);


        if ($test) {
            //verification si le new password est vide
            if ($request->newpassword == null) {
                $user->update([
                    'email' => $request->email,
                    'firstname' => $request->firstname,
                    'phone' => $request->phone,
                    'lastname' => $request->lastname,
                ]);
                return response()->json([
                    'code' => 200,
                    'message' => 'Vos informations sont a jours'
                ]);
            }
            $user->update([
                'email' => $request->email,
                'password' => Hash::make($request->newpassword),
                'firstname' => $request->firstname,
                'phone' => $request->phone,
                'lastname' => $request->lastname,
            ]);
            return response()->json([
                'code' => 200,
                'message' => 'Vos informations sont a jours'
            ]);
        }
        return response()->json([
            'code' => 400,
            'message' => 'Mot de passe actuel incorrect'
        ]);
    }

    //Login
    public function login(Request $request)
    {
        $incomingsFields = $request->validate([
            'email' => 'required',
            'password' => 'required'
        ]);

        if (Auth::attempt($incomingsFields)) {
            $user = User::where('email', $incomingsFields['email'])->first();
            $token = $user->createToken('OurAppToken')->plainTextToken;
            return response()->json([
                'token' => $token,
                'message' => 'success',
                'role' => Auth::user()->role,
                'status' => Auth::user()->status,
            ], 200);
        } else {
            return response()->json([
                'message' => 'Veuiller vérifier votre mot de passe ou bien votre email'
            ]);
        }
    }

    //Registration
    public function registration(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'firstname' => 'required|string|max:50',
            'lastname' => 'required|string|max:50',
            'email' => 'required|email',
            'phone' => 'required|max:10',
        ], [
            'email.email' => 'ataovy email le izy '
        ]);

        if ($validator->fails()) {
            return response()->json([
                'notif' => 'Veuillez remplir tous les champs',
                'message' => 'warning'
            ]);
        }

        // Check if the email address already exists in the database
        $user = User::where('email', $request->email)->first();
        if ($user) {
            return response()->json([
                'notif' => 'L\'adresse e-mail existe déjà.',
                'message' => 'warning'
            ]);
        }
        //generate a token
        $randomString = bin2hex(random_bytes(16)).time();

        // Create a new user  
        $user = User::create([
            'firstname' => $request->firstname,
            'lastname' => $request->lastname,
            'email' => $request->email,
            'phone' => $request->phone,
            'badgeToken' => $randomString,
        ]);

        //response 
        return response()->json([
            'notif' => 'Compte créé avec succès',
            'message' => 'success'
        ]);
    }

    //Supprimer un User
    public function delete(User $user)
    {
        $email = $user->email;
        $user->delete();

        //Mail pour notfier l'organisateur que son compte est supprimé
        Mail::raw(' Votre compte est rejeter  ', function ($message) use ($email) {
            $message->to($email)
                ->subject('Compte supprimé');
        });

        return response()->json([
            'message' => 'deleted'
        ]);
    }

    //Affficher
    public function allUsers()
    {
        $users = User::whereNotIn('role', ['admin'])->paginate(5);
        return response()->json($users);
    }

    //Tous les comptes clients 
    public function allClient()
    {
        $users = User::where('role', '0')->get();
        return response()->json($users);
    }

    //Nb total  comptes clients
    public function countAllClient()
    {
        $users = User::where('role', '0')->count();
        return response()->json($users);
    }

    //Nb total compte Organisateurs
    public function countAllOrganisateur()
    {
        $users = User::where('role', 'organisateur')->count();
        return response()->json($users);
    }

    //one user 
    public function oneUser(User $user)
    {
        return response()->json($user);
    }

    public function infoOrgan(User $user)
    {
        $nom = $user->name;
        //nombre event creer 
        $nbEvent = $user->eventy()->count();
        $data = $user->eventy()->get();

        $revenus = 0;
        foreach ($data as $element) {
            $revenus += $element->billetsVendus * $element->prix;
        }


        return response()->json([
            'nom' => $nom,
            'nbEvent' => $nbEvent,
            'revenus' => $revenus
        ]);
    }
}
