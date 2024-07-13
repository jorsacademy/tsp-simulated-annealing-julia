using Random
using Printf

const NUM_CITIES = 20
const COORDS = [rand(2) for _ in 1:NUM_CITIES]

function euclidean_distance(p1, p2)
    return sqrt((p1[1] - p2[1])^2 + (p1[2] - p2[2])^2)
end

function total_distance(tour)
    dist = 0.0
    for i in 1:(length(tour) - 1)
        dist += euclidean_distance(COORDS[tour[i]], COORDS[tour[i+1]])
    end
    dist += euclidean_distance(COORDS[tour[end]], COORDS[tour[1]])
    return dist
end

function initial_tour()
    return shuffle(1:NUM_CITIES)
end

function swap_cities(tour)
    i, j = sort(rand(1:NUM_CITIES, 2))
    new_tour = copy(tour)
    new_tour[i], new_tour[j] = new_tour[j], new_tour[i]
    return new_tour
end

function simulated_annealing()
    current_tour = initial_tour()
    current_distance = total_distance(current_tour)
    best_tour = copy(current_tour)
    best_distance = current_distance
    T = 100.0
    alpha = 0.995

    while T > 1e-3
        new_tour = swap_cities(current_tour)
        new_distance = total_distance(new_tour)
        ΔE = new_distance - current_distance

        if ΔE < 0 || exp(-ΔE / T) > rand()
            current_tour = new_tour
            current_distance = new_distance

            if current_distance < best_distance
                best_tour = copy(current_tour)
                best_distance = current_distance
            end
        end

        T *= alpha
    end

    return best_tour, best_distance
end

best_tour, best_distance = simulated_annealing()

@printf("Best tour found: %s\n", join(best_tour, " -> "))
@printf("Total distance: %.2f\n", best_distance)
