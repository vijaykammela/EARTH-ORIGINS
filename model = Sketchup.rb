model = Sketchup.active_model
model.start_operation("Create Sphere", true)

radius = 300.mm  # Change sphere radius here
segments = 48
rings = 24

group = model.active_entities.add_group
group.name = "Sphere"
entities = group.entities

point = lambda do |ring, segment|
  latitude = Math::PI * ring / rings
  longitude = 2.0 * Math::PI * segment / segments

  Geom::Point3d.new(
    radius * Math.sin(latitude) * Math.cos(longitude),
    radius * Math.sin(latitude) * Math.sin(longitude),
    radius * Math.cos(latitude)
  )
end

rings.times do |i|
  segments.times do |j|
    a = point.call(i, j)
    b = point.call(i + 1, j)
    c = point.call(i + 1, j + 1)
    d = point.call(i, j + 1)

    vertices =
      if i == 0
        [a, b, c]
      elsif i == rings - 1
        [a, b, d]
      else
        [a, b, c, d]
      end

    entities.add_face(vertices)
  end
end

entities.grep(Sketchup::Edge).each do |edge|
  edge.soft = true
  edge.smooth = true
end

model.commit_operation
model.selection.clear
model.selection.add(group)
model.active_view.zoom(group)