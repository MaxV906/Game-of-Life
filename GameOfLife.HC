
#define ESC_KEY 27

#define SQUARE_SIZE 20

#define SCREEN_WIDTH 620
#define SCREEN_HEIGHT 460

#define SIMULATION_SPEED 300

#define SIMULATION_SEED 0 // Takes seed from a timer

I32 cells[SCREEN_HEIGHT / SQUARE_SIZE][SCREEN_WIDTH / SQUARE_SIZE];


U0 DrawGrids(CDC* dc) {

  U32 x, y, i;

  dc->color = BLACK;

  for (i = 1; i <= SCREEN_WIDTH / SQUARE_SIZE; i++) {

    x = SQUARE_SIZE * i;
    GrLine(dc, x, SQUARE_SIZE, x, SCREEN_HEIGHT);

  }

  for (i = 1; i <= SCREEN_HEIGHT / SQUARE_SIZE; i++) {

    y = SQUARE_SIZE * i;
    GrLine(dc, SQUARE_SIZE, y, SCREEN_WIDTH, y);

  }  

}

U0 DrawCubes(CDC* dc) {

  U32 x, y, i, j;
 
  dc->color = BLUE;

  for (i = 1; i < SCREEN_HEIGHT / SQUARE_SIZE; i++) {

    for (j = 1; j < SCREEN_WIDTH / SQUARE_SIZE; j++) {

      x = SQUARE_SIZE * j;
      y = SQUARE_SIZE * i;

      if (cells[i][j]) {


        GrRect(dc, x, y, SQUARE_SIZE, SQUARE_SIZE);

      }

    }

  }

}

U0 CellsInit() {

  I32 i, j;

  for (i = 0; i < SCREEN_HEIGHT / SQUARE_SIZE; i++) {

    for (j = 0; j < SCREEN_WIDTH / SQUARE_SIZE; j++) {

      cells[i][j] = RandI32($ER$) % 2;

    }

  }

}

I32 CountLiveNeighbours(I32 x, I32 y) {

  I32 neighbour_count = 0;

  I32 x_off, y_off;

  for (x_off = x - 1; x_off <= x + 1; x_off++) {

    for (y_off = y - 1; y_off <= y + 1; y_off++) {

      if (cells[y_off][x_off]) neighbour_count++;

    }

  }

  neighbour_count -= cells[y][x];

  return neighbour_count;

}

U0 UpdateCells() {

  I32 x, y;
  static I32 next_gen[SCREEN_HEIGHT / SQUARE_SIZE][SCREEN_WIDTH / SQUARE_SIZE];

  for (y = 1; y < SCREEN_HEIGHT / SQUARE_SIZE; y++) {

    for (x = 1; x < SCREEN_WIDTH / SQUARE_SIZE; x++) {

      I32 live_neighbours = CountLiveNeighbours(x, y);

      if (cells[y][x]) {

	if (live_neighbours < 2 || live_neighbours > 3) next_gen[y][x] = 0;
	else next_gen[y][x] = 1;

      } else {

	if (live_neighbours == 3) next_gen[y][x] = 1;
	else next_gen[y][x] = 0;

      }

    }

  }

  for (y = 1; y < SCREEN_HEIGHT / SQUARE_SIZE; y++) {

    for (x = 1; x < SCREEN_WIDTH / SQUARE_SIZE; x++) {

      cells[y][x] = next_gen[y][x];

    }

  }

}


U0 GameOfLife(I32 sim_seed = SIMULATION_SEED, I32 sim_speed = SIMULATION_SPEED) {
  
  CDC* dc = DCAlias;

  CellsInit;

  SettingsPush;
  WinMax;
  WinBorder;
  DocCursor;
  DocClear;

  Seed(sim_seed);

  while (ScanChar != ESC_KEY) {

    DrawCubes(dc);
    DrawGrids(dc);
    UpdateCells();
    Sleep(sim_speed);
    DCFill;

  }

  DCFill;
  DCDel(dc);
  SettingsPop;

}

GameOfLife;