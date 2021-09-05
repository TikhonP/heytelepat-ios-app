//
//  ProfileView.swift
//  Speaker
//
//  Created by Тихон on 22.08.2021.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var rootViewModel: RootViewModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
        if networkMonitor.isConnected {
            VStack {
                if profileViewModel.profileData == nil {
                    CustomProgressView()
                } else {
                    VStack {
                        VStack {
                            AsyncImage(
                                url: getUrlProfileImage(),
                                placeholder: { ProgressView() },
                                image: { Image(uiImage: $0).resizable() }
                            )
                                .frame(width: 150, height: 150)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                                .padding()
                            
                            VStack {
                                HStack {
                                    Text(profileViewModel.profileData!.data.name)
                                        .bold()
                                        .font(.title)
                                    Spacer()
                                }
                                HStack {
                                    Text(profileViewModel.profileData!.data.birthday)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    Spacer()
                                }
                            }
                            .padding()
                            
                            Form {
                                Section {
                                    HStack {
                                        Text("Email")
                                        Spacer()
                                        Text(profileViewModel.profileData!.data.email ?? "не указан")
                                            .foregroundColor(.gray)
                                    }
                                    HStack {
                                        Text("Телефон")
                                        Spacer()
                                        Text(profileViewModel.profileData!.data.phone ?? "не указан")
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Section {
                                    Button (action: unauthButtonAction, label: {
                                        Text("Выйти")
                                            .bold()
                                            .accessibility(label: Text("Выйти из аккаунта"))
                                    })
                                }
                            }
                        }
                    }
                }
            }
            .alert(isPresented: $profileViewModel.fetchDataError, content: {
                Alert(title: Text("Ошибка загрузки данных."))
            })
            .onAppear(perform:  { profileViewModel.fetchProfileData(rootViewModel: rootViewModel) })
        } else {
            OfflineView()
        }
    }
    
    func unauthButtonAction() {
        KeyChainTokenViewModel().deleteTokens()
        rootViewModel.updateProperty()
    }
    
    func getUrlProfileImage() -> URL {
        var resourceURLComponents = URLComponents()
        resourceURLComponents.scheme = "https"
        resourceURLComponents.host = medsengerApiDomain
        resourceURLComponents.path = "/api/client/photo/"
        resourceURLComponents.queryItems = [
            URLQueryItem(name: "api_token", value: medsengerApiKey),
        ]
        return resourceURLComponents.url!
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(NetworkMonitor())
            .environmentObject(RootViewModel())
    }
}
