package gforce.arena;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.view.MotionEvent;
import static gforce.arena.UniverseVariables.*;
import static gforce.arena.UniverseConstants.*;


/* ---DETAILS---
 *             ExampleGForce.java extends Universe.java
 * Engine:     Universe.java
 * InputClass: ExampleGForceState.java
 *             **Place the class that extends UniverseState.java between < > (i.e. <ExampleGForceState>)
 */

//Universe has algorithms in the back end that control Thread timings and delays to create maximum fps.
public class ExampleHeli extends Universe<ExamplHeliState>{
	public ExampleHeli(int surfaceID){
		//Here just keep the surfaceID section the same, and then pass in the class that extends UniverseState
		super(surfaceID, ExamplHeliState.class);		
	}

	@Override
	public void onCache(ExamplHeliState s) throws Exception {
		s.bg = decodeResource(R.drawable.carbon_brown);
		
	}

	@Override
	public void onTick(ExamplHeliState s) throws Exception {
		// TODO Auto-generated method stub
	}

	@Override
	public void onPrerender(ExamplHeliState s) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onDraw(ExamplHeliState s, Canvas c) throws Exception {
	}

	@Override
	public void onStop(ExamplHeliState s) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onTouch(ExamplHeliState s, MotionEvent me) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onError(ExamplHeliState s, Exception e) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onPaneCreate(ExamplHeliState s) throws Exception {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onValueChange(ExamplHeliState s, int selection, boolean check,
			int id) throws Exception {
		// TODO Auto-generated method stub
		
	}
}
class ExamplHeliState extends UniverseState{
	
	Bitmap bg;
	int count = 0;
	@Override
	public void onMultithreading(Thread touch, Thread tick, Thread drawer) {
		// TODO Auto-generated method stub
		
	}		
}