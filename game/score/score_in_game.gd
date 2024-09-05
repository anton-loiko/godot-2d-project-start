extends Node2D


var score = 0;

func add_score():
	score += 1
	%Score.text = str(score)
