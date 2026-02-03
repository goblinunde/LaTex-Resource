# recommender.py

import pandas as pd
import numpy as np
from scipy.sparse.linalg import svds

# Daten: "ml-latest-small.zip" von https://grouplens.org/datasets/movielens/latest/

# Daten einlesen
ratings = pd.read_csv("programming_python/ratings.csv", header=0)
movies = pd.read_csv("programming_python/movies.csv", header=0)

# Unrelevante Daten entfernen
ratings = ratings.drop(columns=["timestamp"])
movies = movies.drop(columns="genres")

# Nutzer-Item-Matrix erstellen
user_item_table = ratings.pivot(
    index="userId", columns="movieId", values="rating"
).fillna(0)
R = user_item_table.values

# Trunkierte Rang-k SVD
U, S, Vt = svds(R, k=10)
Sigma = np.diag(S)
prediction_matrix = U @ Sigma @ Vt


# Generieren der Empfehlungen zu einer userId
def recommender(R, prediction_matrix, num_recom, user):
    user_idx = user - 1  # userId startet bei 1
    sorted_predictions = np.argsort(-prediction_matrix[user_idx])
    unwatched_indices = np.where(R[user_idx] == 0)[0]
    recommended_movies_indices = [
        int(movie) for movie in sorted_predictions if movie in unwatched_indices
    ][:num_recom]
    recommended_movies_ids = [
        int(user_item_table.columns[idx]) for idx in recommended_movies_indices
    ]  # Entsprechende movieIds zu den Spaltennummern
    recommended_movies = [
        movies.loc[movies["movieId"] == id, "title"].iloc[0]
        for id in recommended_movies_ids
    ]  # Entsprechende Filmnamen zu den movieIds
    return recommended_movies


# Kosinus-Ähnlichkeit
def cosine_similarity(v, u):
    return (v @ u) / (np.linalg.norm(v) * np.linalg.norm(u))


# Generieren der ähnlichsten Filme zu einer movieId
def similar_movies(movie_id_similar, num_similar):
    movie_idx = np.where(user_item_table.columns == movie_id_similar)[0][
        0
    ]  # Spaltennummer zu gegebener movieId
    movie_vector = Vt[:, movie_idx]
    similarities = np.array(
        [cosine_similarity(Vt[:, i], movie_vector) for i in range(Vt.shape[1])]
    )
    similar_movie_indices = np.argsort(-similarities)[1 : num_similar + 1]
    similar_movie_ids = [
        int(user_item_table.columns[idx]) for idx in similar_movie_indices
    ]  # Entsprechende movieIds zu den Spaltennummern
    similar_movie_titles = [
        movies.loc[movies["movieId"] == id, "title"].iloc[0] for id in similar_movie_ids
    ]  # Entsprechende Filmnamen zu den movieIds
    return similar_movie_titles


num = 5  # Gewünschte Anzahl an Empfehlungen
usr = 3  # Gewünschte userId

# Output
print(
    "Die Top",
    num,
    "Empfehlungen für Nutzer",
    usr,
    "sind",
    recommender(R, prediction_matrix, num, usr),
)

num_sim = 5  # Gewünschte Anzahl an ähnlichen Filmen
mov_sim = 79132  # Gewünschte movieId

# Output
print(
    "Die Top",
    num_sim,
    "ähnlichsten Filme zu Film-ID",
    mov_sim,
    "(" + movies.loc[movies["movieId"] == mov_sim, "title"].iloc[0] + ")",
    "sind:",
    similar_movies(mov_sim, num_sim),
)
