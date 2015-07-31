#include "RakAssert.h"
#include "RakMemoryOverride.h"
#include "TransformationHistory.h"

TransformationHistoryCell::TransformationHistoryCell()
{

}
TransformationHistoryCell::TransformationHistoryCell(RakNet::TimeMS t, float x, float y, int vx, int vy, int state):
_time(t),
_x(x),
_y(y),
_velocityX(vx),
_velocityY(vy)
{
}

void TransformationHistory::Init(RakNet::TimeMS maxWriteInterval, RakNet::TimeMS maxHistoryTime)
{
	writeInterval = maxWriteInterval;
	maxHistoryLength = maxHistoryTime/maxWriteInterval+1;
	history.ClearAndForceAllocation(maxHistoryLength+1, _FILE_AND_LINE_ );
	RakAssert(writeInterval>0);
}

void TransformationHistory::Write(float x, float y, int vx, int vy, int state, RakNet::TimeMS curTimeMS)
{
	if (history.Size() == 0)
	{
		history.Push(TransformationHistoryCell(curTimeMS, x, y, vx, vy, state), _FILE_AND_LINE_ );
	}
	else
	{
		const TransformationHistoryCell &lastCell = history.PeekTail();
		if (curTimeMS - lastCell._time >= writeInterval)
		{
			history.Push(TransformationHistoryCell(curTimeMS, x, y, vx, vy, state), _FILE_AND_LINE_ );
			if (history.Size() > maxHistoryLength)
				history.Pop();
		}
	}	
}

void TransformationHistory::Overwrite(float x, float y, int vx, int vy, int state, RakNet::TimeMS when)
{
	int historySize = history.Size();
	if (historySize == 0)
	{
		history.Push(TransformationHistoryCell(when, x, y ,vx, vy ,state), _FILE_AND_LINE_ );
	}
	else
	{
		// Find the history matching this time, and change the values.
		int i;
		for (i = historySize - 1; i >= 0; i--)
		{
			TransformationHistoryCell &cell = history[i];
			if (when >= cell._time)
			{
				if (i == historySize-1 && when-cell._time>=writeInterval)
				{
					// Not an overwrite at all, but a new cell
					history.Push(TransformationHistoryCell(when, x, y, vx, vy, state), _FILE_AND_LINE_ );
					if (history.Size()>maxHistoryLength)
						history.Pop();
					return;
				}

				cell._time = when;
				cell._x = x;
                cell._y = y;
                cell._velocityX = vx;
                cell._velocityY = vy;
                cell._state = state;
				return;
			}
		}
	}	
}

TransformationHistory::ReadResult TransformationHistory::Read(float *x, float *y, int *vx, int *vy, int *state, RakNet::TimeMS when, RakNet::TimeMS curTime)
{
	int historySize = history.Size();
	if (historySize == 0)
	{
		return VALUES_UNCHANGED;
	}

	int i;
	for (i = historySize - 1; i >= 0; i--)
	{
		const TransformationHistoryCell &cell = history[i];
		if (when >= cell._time)
		{
			if (i == historySize-1)
			{
				if (curTime <= cell._time)
					return VALUES_UNCHANGED;

				float divisor = (float)(curTime - cell._time);
				RakAssert(divisor != 0.0f);
				float lerp = (float)(when - cell._time) / divisor;
                // cell._x === *x ? so the result is always cell.x
                // we will improve this later: dead reckoning
				if (x)
					*x = cell._x + (*x - cell._x) * lerp;
				if (y)
					*y = cell._y + (*y - cell._y) * lerp;
                if (vx)
					*vx = cell._velocityX + (*vx - cell._velocityX) * lerp;
                if (vy)
					*vy = cell._velocityY + (*vy - cell._velocityY) * lerp;
                if (state)
					*state = cell._state + (*state - cell._state) * lerp;
			}
			else
			{
				const TransformationHistoryCell &nextCell = history[i+1];
				float divisor = (float)(nextCell._time - cell._time);
				RakAssert(divisor != 0.0f);
				float lerp = (float)(when - cell._time) / divisor;
				if (x)
					*x = cell._x + (nextCell._x - cell._x) * lerp;
				if (y)
					*y = cell._y + (nextCell._y - cell._y) * lerp;
                if (vx)
					*vx = cell._velocityX + (nextCell._velocityX - cell._velocityX) * lerp;
                if (vy)
					*vy = cell._velocityY + (nextCell._velocityY - cell._velocityY) * lerp;
                if (state)
					*state = cell._state + (nextCell._state - cell._state) * lerp;
			}
			return INTERPOLATED;
		}
	}

	// Return the oldest one
	const TransformationHistoryCell &cell = history.Peek();
	if (x)
		*x = cell._x;
	if (y)
		*y = cell._y;
    if (x)
		*x = cell._x;
	if (vx)
		*vx = cell._velocityX;
    if (vy)
		*vy = cell._velocityY;
	if (state)
		*state = cell._state;
	return READ_OLDEST;
}

void TransformationHistory::Clear(void)
{
	history.Clear(_FILE_AND_LINE_);
}