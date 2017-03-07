function aabb(a, b, size) {
    return a.x + size >= b.x && b.x + size >= a.x &&
        a.y + size >= b.y && b.y + size >= a.y;
}