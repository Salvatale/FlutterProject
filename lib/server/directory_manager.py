import os

def get_user_directory(user_id):

    directory = "./data/" + user_id

    elements = os.listdir(directory)

    directory_list = [element for element in elements if os.path.isdir(os.path.join(directory,element))]

    return directory_list

def create_user_directory(user_id):

    path_directory = "./data/" + user_id
    os.mkdir(path_directory)
    
