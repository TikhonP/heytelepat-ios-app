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
                                url: getUrlProfileImage(), placeholder: { ProgressView() })
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .shadow(radius: 10)
                                .padding()
                            VStack {
                                Text(profileViewModel.profileData!.data.name)
                                    .bold()
                                    .font(.title)
                                Text(profileViewModel.profileData!.data.birthday)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }.padding()
                            List {
                                HStack {
                                    Text("Email")
                                        .bold()
                                        .lineLimit(1)
                                    Text(profileViewModel.profileData!.data.email ?? "не указан")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }
                                HStack {
                                    Text("Телефон")
                                        .bold()
                                        .lineLimit(1)
                                    Text(profileViewModel.profileData!.data.phone ?? "не указан")
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }
                            }.padding()
                        }
                        Spacer()
                        Button (action: unauthButtonAction, label: {
                            Text("Выйти")
                                .bold()
                                .accessibility(label: Text("Выйти из аккаунта"))
                        })
                        .padding()
                    }
                }
            }
            .alert(isPresented: $profileViewModel.fetchDataError, content: {
                Alert(title: Text("Ошибка загрузки данных."))
            })
            .onAppear(perform: profileViewModel.fetchProfileData)
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
