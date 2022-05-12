function plotting(pos, pos_EE,color)
hold on
grid on
xlim([0 1])
ylim([-0.4 0.4])
xlabel('x')
ylabel('y')
a=0.1;
b=0.05;
quiver([0,0],[0,0],[1,0],[0,1], a, 'filled','LineWidth', 1,'Color_I','k')
rectangle('Position', [0, 0, b, b],'FaceColor',[0 0 0 ])
text(0, -0.01, 'robot base')
for i=size(pos,1):-1:1
quiver([pos(i,1),pos(i,1)],[pos(i,2), pos(i,2)],[1,0],[0,1], a, 'filled','LineWidth', 1,'Color_I', [color(i,1) color(i,2)  color(i,3) ])
rectangle('Position', [pos(i,1)-b, pos(i,2)-b, 2*b, 2*b],'FaceColor',[color(i,1) color(i,2)  color(i,3) ])
text(pos(i,1)+0.02, pos(i,2)+0.02, num2str(i))
end
rectangle('Position', [pos_EE(1)-b/2, pos_EE(2)-b/2, b, b],'FaceColor',[0.2 0.2 0], 'Curvature', [1,1])
end
